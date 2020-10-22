require_relative "stacklog.rb"

key = "sk_i3rs7wglwro5yzdwsb9sif6cm2c8xx"
bucket_id = 'bk_m2dwcic429s1dl4txz5u22jj9d2jwj'


logger = StackLog::Ruby.new(key, bucket_id)

logger.info { 'This is an info message' }