require './test/test_helper'

class GeneratorTest < TestHelper
  def test_it_generates_a_random_password_of_default_12_chars
    password = gen.generate_password

    assert_equal password.length, 12
    assert password.match(/[a-z]/)
    assert password.scan(/[A-Z]/).count > 0
    assert password.scan(/[0-9]/).count > 0
    assert password.scan(/[!@#$%^&*()]/).count > 0
  end

  def test_it_stores_an_account_with_username
    skip if ENV['s']
    meta_data = gen.create_new_account(account: 'test', username: 'test@test.com', length: 12)
    csv = load_csv
    clean_test_csvs

    assert_equal csv[:username], ['test@test.com']
    assert_equal csv[:password], [meta_data[:password]]
  end
end
