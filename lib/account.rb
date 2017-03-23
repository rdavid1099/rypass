require "#{PATH}/config/setup"

class Account
  attr_reader :account, :destination

  def initialize(**args)
    @account = args[:account].nil? ? get_account_name : args[:account].downcase
    args[:destination] ||= '~/Library/RyPass'
    @destination = File.expand_path(args[:destination]).downcase
    @username = args[:username].nil? ? nil : args[:username].downcase
    load_csv
  end

  def usernames
    Message::Statement.display_usernames(raw_data.keys)
  end

  def get_password
    @username ||= get_username
    if raw_data.keys.include?(@username)
      Message::Statement.display_password(raw_data[@username])
    else
      raise RuntimeError, Message::Error.username_not_found(@username)
    end
  end

  def all
    Message::Statement.display_all_account_data(raw_data.to_a)
  end

  private
    attr_reader :raw_data

    def load_csv
      if sanitize!(Dir["#{destination}/*.csv"]).include?("#{destination}/#{account}.csv")
        @raw_data = {}
        CSV.foreach("#{destination}/#{account}.csv", headers: true) do |row|
          @raw_data[row[0]] = row[1] unless row[0] == 'username'
        end
      else
        raise RuntimeError, "Account '#{account}' not found in directory '#{destination}'"
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
