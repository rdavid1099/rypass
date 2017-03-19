require 'csv'
require 'fileutils'
require 'pry'

Dir.glob('./lib/*.rb').each { |file| require file.sub('.rb','') }
