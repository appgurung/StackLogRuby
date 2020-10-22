
<p align="center">
  <a href="https://stacklog.io">
    StackLog
  </a>
  <p align="center">Ruby gem for logging to <a href="https://stacklog.io">StackLog</a></p>
</p>

---

* **[Installation](#installation)**
* **[Quick Setup](#quick-setup)**
* **[API](#api)**
* **[Contributing](#contributing)**
* **[License](#license)**

# Installation

Add this line to your application's Gemfile:

```ruby
gem 'stacklog'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install stacklog



# Quick Setup

After installation, call

    logger = StackLog::Ruby.new(your_api_key, options)
    => #<StackLog::Ruby:0x00000000000000>

to set up the logger.

Options are optional variables that may contain hostname, app name, mac address, ip address, log level specified.

    options = {
        :hostname => myHostName,
        :ip =>  myIpAddress,
        :mac => myMacAddress,
        :app => myAppName,
        :level => "INFO",    # LOG_LEVELS = ['DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL'] or your customized log level (custom levels for Rails have to be sent with a log message)
        :env => "PRODUCTION",
        :meta => {:once => {:first => "nested1", :another => "nested2"}},
        :endpoint => "http://www.stacklog.io:8873/api/v1/sandbox/log/create/"
    }

To send logs, use "log" method. Default log level is "INFO"

    logger.log('My first log')
    => "Saved"  # Saved to buffer. Ready to be flushed automatically

Optionally you can use a block to do so

    logger.log { 'My second log' }
    => "Saved"

Log a message with particular metadata, level, appname, environment (one-time)

    logger.log('This is warn message', {:meta => {:meta => "data"}, :level => "WARN", :env => "DEVELOPMENT"})

Log a message with lasting metadata, level, appname, environment (lasting)

    logger.meta = {:once => {:first => "nested1", :another => "nested2"}}
    logger.level = 'FATAL'  or  logger.level = Logger::FATAL
    logger.env = 'PRODUCTION'
    logger.log('This messages and messages afterwards all have the above values')

Clear current metadata, level, appname, environment

    logger.clear

Check current log level:
    logger.info? => true
    logger.warn? => false

Log a message with a particular level easily

    logger.warn('This is a warning message')
    logger.fatal('This is a fatal message')
    logger.debug { 'This is a debug message' }


Hostname and app name cannot be more than 80 characters.

### Rails Setup
In your `config/environments/environment.rb`:

  ```
  Rails.application.configure do
    config.logger = StackLog::Ruby.new(your_api_key, options)
  end
  ```

# Important Notes

1. This logger assumes that you pass in json formatted data
2. This logger is a singleton (do not create mutiple instances of the logger) even though the singleton structure is not strongly enforced.

# API

## StackLog::Ruby.new(ingestion_key, options = {})

Instantiates a new instance of the class it is called on. ingestion_key is required.

| Options | Default |
|---------|---------|
|{ :hostname => Host name } | Device's default hostname |
|{ :mac => MAC address } | Nil |
|{ :ip => IP address } | Nil |
|{ :level => Log level } | 'INFO' |
|{ :env => STAGING, PRODUCTION .. etc} | Nil |
|{ :meta => metadata} | Nil |
|{ :endpoint => StackLog Ingestion URI | 'stacklog.io/logs' |
|{ :flushtime => Log flush interval in seconds } | 0.25 seconds |
|{ :flushbyte => Log flush upper limit in bytes } | 500000 bytes ~= 0.5 megabytes |

Different log level displays log messages in different colors as well.
- ![DEBUG INFO Colors](https://placehold.it/15/515151/000000?text=+)   "Debug"  "Info"
- ![WARN Color](https://placehold.it/15/ec9563/000000?text=+)   "Warn"
- ![ERROR Fatal Colors](https://placehold.it/15/e37e7d/000000?text=+)   "Error"  "Fatal"



# Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/appgurung/StackLogRuby.



# License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
