require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require './config/setup'

class TestHelper < Minitest::Test
  attr_reader :gen
  PASS = Password.new
  FILE = FileIt.new

  def setup
    @gen = Generator.new
  end

  def generate_test_account(amount = 1, name = 'test')
    amount.times do |i|
      FILE.save(account: name, username: "test#{i}@test.com", password: "password#{i}")
    end
  end

  def clean_test_csvs
    `rm -r #{File.expand_path('~/Library/RyPass/*')}`
  end

  def load_csv
    CSV.read('/Users/RyanWorkman/Library/RyPass/test.csv', headers: true, header_converters: :symbol)
  end
end
