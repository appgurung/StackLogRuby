# frozen_string_literal: true

require "net/http"
require "socket"
require "json"
require "concurrent"
require "date"

module StackLog
  class Client
    def initialize(uri, key, opts)
      @uri = uri
      @key = key
      # NOTE: buffer is in memory
      @buffer = []
      @buffer_byte_size = 0

      @side_messages = []

      @lock = Mutex.new
      @side_message_lock = Mutex.new
      @flush_limit = opts[:flush_size] || Resources::FLUSH_BYTE_LIMIT
      @flush_interval = opts[:flush_interval] || Resources::FLUSH_INTERVAL
      @flush_scheduled = false
      @exception_flag = false

      @retry_timeout = opts[:retry_timeout] || Resources::RETRY_TIMEOUT

      @internal_logger = Logger.new(STDOUT)
      @internal_logger.level = Logger::INFO

      process_message(opts)
    end


    def process_message(msg, opts = {})
      processed_message = {
        line: msg,
        app: opts[:app],
        level: opts[:level],
        env: opts[:env],
        meta: opts[:meta],
        timestamp: Time.now.to_i,
      }
      processed_message.delete(:meta) if processed_message[:meta].nil?
      processed_message
      send_request(msg, opts[:level])
    end

    def schedule_flush
      start_timer = lambda {
        sleep(@exception_flag ? @retry_timeout : @flush_interval)
        flush if @flush_scheduled
      }
      Thread.new { start_timer.call }
    end

    def write_to_buffer(msg, opts)
      if @lock.try_lock
        processed_message = process_message(msg, opts)
        new_message_size = processed_message.to_s.bytesize
        @buffer.push(processed_message)
        @buffer_byte_size += new_message_size
        @flush_scheduled = true
        @lock.unlock

        if @flush_limit <= @buffer_byte_size
          flush
        else
          schedule_flush
        end
      else
        @side_message_lock.synchronize do
          @side_messages.push(process_message(msg, opts))
        end
      end
    end

    # This method has to be called with @lock
    def send_request(msg, level)
      puts level
      
      
      uri = @uri
      key = @key
      header = {'Content-Type': 'application/json', 'secretKey': key}
      data = {
                logMessage: msg,
                stackKey: 'otLrwnc3z',
                logTypeId: 1
              }

      # Create the HTTP objects
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.request_uri, header)
      request.body = data.to_json

      # Send the request
      response = http.request(request)
    end

    def flush
      if @lock.try_lock
        @flush_scheduled = false
        if @buffer.any? || @side_messages.any?
          send_request
        end
        @lock.unlock
      else
        schedule_flush
      end
    end

    def exitout
      flush
      @internal_logger.debug("Exiting StackLog logger: Logging remaining messages")
    end
  end
end
