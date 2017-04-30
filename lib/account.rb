require "#{PATH}/config/setup"

# Get basic username and password data attached to a given account
class Account
  # @return [String] the name of the account
  attr_reader :account

  # @return [String] the pathname where the account csv will be saved and/ or loaded
  attr_reader :destination

  # Initialize Account with a hash of options
  #
  # @param [Hash] opts the options to create an account with
  # @option opts [String] :account the name of the account
  # @option opts [String] :destination ('~/Library/RyPass') the pathname where the account csv will be saved and/ or loaded
  # @option opts [String] :username the username to be saved and/ or loaded with the associated account
  def initialize(**opts)
    @account = opts[:account].nil? ? get_account_name : opts[:account].downcase
    opts[:destination] ||= '~/Library/RyPass'
    @destination = File.expand_path(opts[:destination]).downcase
    @username = opts[:username].nil? ? nil : opts[:username].downcase
    load_csv
  end

  # Get all usernames attached to account
  #
  # @return [String] all usernames saved under given account
  def usernames
    Message::Statement.display_usernames(raw_data.keys)
  end

  # Get password for given username with the account
  #
  # @return [String] the password saved for a specific username with the account
  # @raise [RuntimeError] if username is not found with the account
  def get_password
    @username ||= get_username
    if raw_data.keys.include?(@username)
      encrypt = Encryption.new(raw_data[@username].last)
      password = encrypt.decrypt_password(raw_data[@username].first)
      Message::Statement.display_password(password)
    else
      raise RuntimeError, Message::Error.username_not_found(@username)
    end
  end

  # Get all usernames and respective passwords for the account
  #
  # @return [String] all usernames and passwords attached to account
  def all
    Message::Statement.display_all_account_data(raw_data_to_a)
  end

  private
    attr_reader :raw_data

    def load_csv
      if sanitize!(Dir["#{destination}/*.csv"]).include?("#{destination}/#{account}.csv")
        @raw_data = {}
        CSV.foreach("#{destination}/#{account}.csv", headers: true) do |row|
          @raw_data[row[0]] = [row[1], row[2]] unless row[0] == 'username'
        end
      else
        raise RuntimeError, "Account '#{account}' not found in directory '#{destination}'"
      end
    end

    def raw_data_to_a
      raw_data.reduce([]) do |result, data|
        result << [data[0], Encryption.new(data[1][1]).decrypt_password(data[1][0])]
      end
    end

    def sanitize!(file_paths)
      file_paths.map { |file_path| file_path.downcase }
    end

    def get_account_name
      print Message::Prompt.account_name
      STDIN.gets.downcase.chomp
    end

    def get_username
      print Message::Prompt.username(account)
      STDIN.gets.downcase.chomp
    end
end
