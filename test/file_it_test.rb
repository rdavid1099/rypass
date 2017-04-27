require './test/test_helper'

class FileItTest < TestHelper
  def test_it_saves_new_information_as_csv
    file_io_test
    FILE.save(account: 'test', username: 'test@test.com', password: 'password')
    csv = load_csv
    clean_test_csvs

    assert_equal csv[:username], ['test@test.com']
    assert_equal csv[:password], ['password']
  end

  def test_it_updates_existing_username_with_new_password
    file_io_test
    FILE.save(account: 'test', username: 'test@test.com', password: 'password')
    FILE.save(account: 'test', username: 'thistest@test.com', password: 'password')
    FILE.save(account: 'test', username: 'test@test.com', password: 'newpassword')
    csv = load_csv
    clean_test_csvs

    assert_equal csv[:username], ['thistest@test.com', 'test@test.com']
    assert_equal csv[:password], ['password', 'newpassword']
  end

  def test_it_removes_existing_username_and_password
    file_io_test
    FILE.save(account: 'test', username: 'test@test.com', password: 'password')
    FILE.save(account: 'test', username: 'thistest@test.com', password: 'thispassword')
    result = FILE.destroy(account: 'test', username: 'test@test.com')
    csv = load_csv
    clean_test_csvs

    assert_equal csv[:username], ['thistest@test.com']
    assert_equal csv[:password], ['thispassword']
    assert_equal result, true
  end

  def test_it_returns_false_if_account_does_not_exist
    result = FILE.destroy(account: 'notreal', username: 'test@test.com')

    assert_equal result, false
  end
end
