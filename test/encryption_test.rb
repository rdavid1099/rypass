require './test/test_helper'

class EncryptionTest < TestHelper
  def setup
    @encrypt = setup_test[:encrypt]
  end

  def test_it_can_load_secret_key
    assert_equal @encrypt.send(:secret_key), @encrypt.send(:load_secret_key)
  end

  def test_it_generates_secret_key_if_file_does_not_exist
    assert !@encrypt.send(:secret_key).nil?
  end

  def test_it_creates_a_secret_box
    assert_instance_of RbNaCl::SecretBox, @encrypt.send(:secret_box)
  end

  def test_it_generates_nonce
    assert !@encrypt.nonce.nil?
  end

  def test_it_encrypts_password
    password = 't3stPa$$word!'
    encrypted_password = @encrypt.encrypt_password(password)

    assert password != encrypted_password
  end

  def test_it_decrypts_password
    password = 't3stPa$$word!'
    encrypted_password = @encrypt.encrypt_password(password)
    decrypted_password = @encrypt.decrypt_password(encrypted_password)

    assert_equal password, decrypted_password
  end

  def test_it_decrypts_password_with_known_nonce
    password = 't3stPa$$word!'
    nonce = @encrypt.nonce
    encrypted_password = @encrypt.encrypt_password(password)
    decrypt_with_nonce = Encryption.new(nonce).decrypt_password(encrypted_password)

    assert_equal password, decrypt_with_nonce
  end
end
