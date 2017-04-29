require "#{PATH}/config/setup"

class Encryption
  attr_reader :nonce

  def initialize
    @secret_key = load_secret_key || generate_secret_key
    @secret_box = create_secret_box
    @nonce = RbNaCl::Random.random_bytes(secret_box.nonce_bytes)
  end

  def encrypt_password(password)
    secret_box.encrypt(nonce, password)
  end

  def decrypt_password(encrypted_password)
    secret_box.decrypt(nonce, encrypted_password)
  end

  private
    attr_reader :secret_key, :secret_box

    def load_secret_key
      begin
        YAML.load_file(File.expand_path('./config/encryption.yml'))['SECRET_KEY']
      rescue => e
        false
      end
    end

    def generate_secret_key
      key = RbNaCl::Random.random_bytes(RbNaCl::SecretBox.key_bytes)
      File.open(File.expand_path("#{PATH}/config/encryption.yml"), 'w') do |f|
        f.write "---\nSECRET_KEY: #{key}"
      end
      key
    end

    def create_secret_box
      RbNaCl::SecretBox.new(secret_key)
    end
end
