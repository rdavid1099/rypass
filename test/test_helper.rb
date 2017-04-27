PATH = File.expand_path('~/RyPassSource')

require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require "#{PATH}/config/setup"

class TestHelper < Minitest::Test
  attr_reader :gen
  PASS = Password.new
  FILE = FileIt.new('~/Library/RyPass/test')

  def setup
    @gen = Generator.new('~/Library/RyPass/test')
  end

  def file_io_test
    skip if ENV['s']
  end

  def generate_test_account(amount = 1, name = 'test')
    amount.times do |i|
      FILE.save(account: name, username: "test#{i}@test.com", password: "password#{i}")
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
end
