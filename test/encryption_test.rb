require './test/test_helper'

class EncryptionTest < TestHelper
  def test_it_grabs_key_from_secret_yml
    create_secret_yml
    
  end
end
