require 'csv'
require 'fileutils'
Dir.glob("#{PATH}/lib/*.rb").each { |file| require "#{file.sub('.rb','')}" }
