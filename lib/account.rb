require './config/setup'

class Account
  attr_reader :account, :destination

  def initialize(**args)
    @account = args[:account] || get_account_name
    args[:destination] ||= '~/Library/RyPass'
    @destination = File.expand_path(args[:destination])
    @username = args[:username]
    load_csv
  end

  def usernames
    raw_data.keys
  end

  def get_password
    @username ||= get_username
    if raw_data.keys.include?(@username)
      raw_data[@username]
    else
      raise RuntimeError, Message::Error.username_not_found(@username)
    end
  end

  def all
    raw_data.to_a
  end

  def find_password_for_user(name_query)
    if name_query == username
      password
    else
      puts Message::Error.username_not_found(name_query)
    end
  end

  private
    attr_reader :raw_data

    def load_csv
      if Dir["#{destination}/*.csv"].include?("#{destination}/#{account}.csv")
        @raw_data = {}
        CSV.foreach("#{destination}/#{account}.csv", headers: true) do |row|
          @raw_data[row[0]] = row[1] unless row[0] == 'username'
        end
      else
        raise RuntimeError, "Account '#{account}' not found in directory '#{destination}'"
      end
    end

    def get_account_name
      print Message::Prompt.account_name
      STDIN.gets.downcase.chomp
    end

    def get_username
      print Message::Prompt.username(account)
      STDIN.gets.chomp
    end
end
