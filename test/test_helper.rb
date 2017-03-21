require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require './config/setup'

class TestHelper < Minitest::Test
  attr_reader :gen
  PASS = Password.new
  FILE = FileIt.new('~/Library/RyPass/test')

  def setup
    @gen = Generator.new(destination: '~/Library/RyPass/test')
  end

  def generate_test_account(amount = 1, name = 'test')
    amount.times do |i|
      FILE.save(account: name, username: "test#{i}@test.com", password: "password#{i}")
    end
  end

  def clean_test_csvs
    `rm -r #{File.expand_path('~/Library/RyPass/test/*')}; rmdir #{File.expand_path('~/Library/RyPass/test')}`
  end

  def load_csv
    CSV.read('/Users/RyanWorkman/Library/RyPass/test/test.csv', headers: true, header_converters: :symbol)
  end

  def set_ARGV_values(*params)
    params.each_with_index do |param, i|
      ARGV[i] = param
    end
  end
end
