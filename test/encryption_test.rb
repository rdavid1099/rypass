require './test/test_helper'

class EncryptionTest < TestHelper
  def teardown
    clean_secret_yml
  end

  def test_it_grabs_key_from_secret_yml
    create_secret_yml key: 12345
    encrypt = Encryption.new

    assert_equal 12345, encrypt.send(:secret_key)
  end

  def test_it_can_load_secret_key
    create_secret_yml key: 12345
    encrypt = Encryption.new

    assert_equal 12345, encrypt.send(:load_secret_key)
  end
  
end
