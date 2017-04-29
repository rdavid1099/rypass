unless ENV['s']
  require 'simplecov'
  SimpleCov.start do
    SimpleCov.add_filter 'test'
    SimpleCov.add_filter 'config/setup'
  end
else
  puts "\nNOTE: Coverage not tracked unless running 'rake test:all'\n"
end

PATH = File.expand_path('.')
require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
Dir.glob("#{PATH}/lib/*.rb").each { |file| require "#{file.sub('.rb','')}" }

class TestHelper < Minitest::Test
  def setup_test
    {file: FileIt.new('~/Library/RyPass/test'),
     gen: Generator.new('~/Library/RyPass/test'),
     pass: Password.new,
     encrypt: Encryption.new}
  end

  def file_io_test
    skip if ENV['s']
  end

  def generate_test_account(amount = 1, name = 'test')
    amount.times do |i|
      FileIt.new('~/Library/RyPass/test').save(account: name, username: "test#{i}@test.com", password: "password#{i}")
    end
  end

  def clean_test_csvs
    `rm -r #{File.expand_path('~/Library/RyPass/test')}`
  end

  def clean_exported_csvs
    rypass_path = File.expand_path('./RyPass')
    File.exists?(rypass_path) ? `rm -r #{rypass_path}` : `rm #{File.expand_path('export-test.csv')}`
  end

  def load_csv
    CSV.read(File.expand_path('~/Library/RyPass/test/test.csv'), headers: true, header_converters: :symbol)
  end

  def load_exported_csv
    CSV.read(File.expand_path('export-test.csv'), headers: true, header_converters: :symbol)
  end

  def set_ARGV_values(*params)
    params.each_with_index do |param, i|
      ARGV[i] = param
    end
  end

  def create_secret_yml(key: nil)
    File.open(File.expand_path('./config/encryption.yml'), 'w') do |f|
      f.write "---\nSECRET_KEY: #{key}"
    end
  end

  def clean_secret_yml
    `rm #{File.expand_path('./config/encryption.yml')}`
  end
end
