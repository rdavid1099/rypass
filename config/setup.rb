require 'csv'
require 'fileutils'
require 'yaml'
require 'base64'
require 'rbnacl/libsodium'
Dir.glob("#{PATH}/lib/*.rb").each { |file| require "#{file.sub('.rb','')}" }

ENV['ENCRYPT_PATH'] = if ENV['test']
  File.expand_path('./tmp/config/encryption.yml')
else
  "#{PATH}/config/encryption.yml"
end
