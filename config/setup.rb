require 'csv'
require 'fileutils'

Dir.glob('./lib/*.rb').each { |file| require file.sub('.rb','') }
