require "#{PATH}/config/setup"

class Encryption
  attr_reader :raw_nonce

  def initialize(nonce = nil)
    @secret_key = load_secret_key || generate_secret_key
    @secret_box = create_secret_box
    @raw_nonce = get_raw_nonce(nonce)
  end

  def encrypt_password(password)
    raw_encryption = secret_box.encrypt(raw_nonce, password)
    Base64.encode64(raw_encryption).chomp
  end

  def decrypt_password(encrypted_password)
    raw_encryption = Base64.decode64(encrypted_password)
    secret_box.decrypt(raw_nonce, raw_encryption)
  end

  def nonce
    Base64.encode64(raw_nonce).chomp
  end

  private
    attr_reader :secret_key, :secret_box

    def load_secret_key
      begin
        encrypted_key = YAML.load_file(ENV['ENCRYPT_PATH'])['SECRET_KEY']
        Base64.decode64(encrypted_key)
      rescue => e
        false
      end
    end

    def generate_secret_key
      key = RbNaCl::Random.random_bytes(RbNaCl::SecretBox.key_bytes)
      File.open(ENV['ENCRYPT_PATH'], 'w') do |f|
        f.write "---\nSECRET_KEY: #{Base64.encode64(key)}"
      end
      key
    end

    def get_raw_nonce(nonce)
      if nonce
        Base64.decode64(nonce)
      else
        RbNaCl::Random.random_bytes(secret_box.nonce_bytes)
      end
    end

    def create_secret_box
      RbNaCl::SecretBox.new(secret_key)
    end
end
