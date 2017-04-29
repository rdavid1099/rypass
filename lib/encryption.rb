require "#{PATH}/config/setup"

class Encryption
  attr_reader :nonce

  def initialize(nonce = nil)
    @secret_key = load_secret_key || generate_secret_key
    @secret_box = create_secret_box
    @nonce = nonce || RbNaCl::Random.random_bytes(secret_box.nonce_bytes)
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
        encrypted_key = YAML.load_file(File.expand_path("#{PATH}/config/encryption.yml"))['SECRET_KEY']
        Base64.decode64(encrypted_key)
      rescue => e
        false
      end
    end

    def generate_secret_key
      key = RbNaCl::Random.random_bytes(RbNaCl::SecretBox.key_bytes)
      File.open(File.expand_path("#{PATH}/config/encryption.yml"), 'w') do |f|
        f.write "---\nSECRET_KEY: #{Base64.encode64(key)}"
      end
      key
    end

    def create_secret_box
      RbNaCl::SecretBox.new(secret_key)
    end
end
