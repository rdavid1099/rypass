require './test/test_helper'

class PasswordTest < TestHelper
  def test_it_sanitizes_unacceptable_passwords
    sanitized_password = PASS.sanitize('crappassword')

    assert sanitized_password != 'crappassword'
    assert sanitized_password.scan(/[A-Z]/).count > 0
    assert sanitized_password.scan(/[0-9]/).count > 0
    assert sanitized_password.scan(/[!@#$%^&*()]/).count > 0
    sanitized_password.length.times do |i|
      sanitized_password.chars.each_with_index do |char, index|
        assert sanitized_password[i] != char unless i == index
      end
    end
  end
end
