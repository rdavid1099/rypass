require './test/test_helper'

class AccountTest < TestHelper
  def test_it_reads_all_usernames_of_an_account
    skip if ENV['s']
    generate_test_account(2)
    account = Account.new(account: 'test')
    clean_test_csvs

    assert_equal account.usernames, ['test0@test.com', 'test1@test.com']
  end

  def test_it_finds_password_belonging_to_specific_user
    skip if ENV['s']
    generate_test_account(2)
    account = Account.new(account: 'test')
    clean_test_csvs

    assert_equal account.get_password('test0@test.com'), 'password0'
    assert_equal account.get_password('test1@test.com'), 'password1'
  end

  def test_it_returns_array_of_all_info_stored
    skip if ENV['s']
    generate_test_account(2)
    account = Account.new(account: 'test')
    clean_test_csvs

    assert_equal account.all, [['test0@test.com', 'password0'], ['test1@test.com', 'password1']]
  end
end
