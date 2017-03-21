require './test/test_helper'

class AccountTest < TestHelper
  def test_it_reads_all_usernames_of_an_account
    skip if ENV['s']
    generate_test_account(2)
    account = Account.new(account: 'test', destination: '~/Library/RyPass/test')
    clean_test_csvs

    assert_equal account.usernames, ['Username','test0@test.com', 'test1@test.com'].join("\n")
  end

  def test_it_finds_password_belonging_to_specific_user
    skip if ENV['s']
    generate_test_account(2)
    test0_account = Account.new(account: 'test',
                                destination: '~/Library/RyPass/test',
                                username: 'test0@test.com')
    clean_test_csvs

    assert_equal test0_account.get_password, "Password: password0"
  end

  def test_it_returns_array_of_all_info_stored
    skip if ENV['s']
    generate_test_account(2)
    account = Account.new(account: 'test', destination: '~/Library/RyPass/test')
    clean_test_csvs

    assert_equal account.all, "Username | Password\ntest0@test.com | password0\ntest1@test.com | password1"
  end
end
