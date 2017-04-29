require "#{PATH}/config/setup"

class Encryption
  def initialize
    @secret_key = load_secret_key
  end

  private
    attr_reader :secret_key

    def load_secret_key
      begin
        YAML.load_file(File.expand_path('./config/encryption.yml'))['SECRET_KEY']
      rescue => e
        false
      end
    end
end
