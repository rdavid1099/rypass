require "#{PATH}/config/setup"

class Generator
  attr_reader :username, :account

  def initialize(destination = nil)
    @password_klass = Password.new
    @file_it = FileIt.new(destination)
  end

  def create_new_account(**options)
    @account = options[:account] || get_account_name
    @username = options[:username] || get_username
    @password ||= generate_password options[:length] || get_length
    {
      destination: options[:destination] || '~/Library/RyPass/',
      account: @account,
      username: @username,
      password: @password
    }
  end

  def save_password(password)
    @password = password
    create_new_account
  end

  def create_new_user(new_username)
    if username
      raise RuntimeError, Message::Error.username_exists(username)
    else
      @username = new_username
      generate_password
    end
  end

  def generate_password(length = 12)
    password_klass.generate_new(length)
  rescue
    raise RuntimeError, Message::Error.too_many_characters
    create_new_account(account: account, username: username)
  end

  private
    attr_reader :password_klass, :file_it, :password

    def save_information
      if file_it.save(account: account.downcase, username: username.downcase, password: password)
        password
      else
        raise RuntimeError, Message::Error.general(file_it.errors.join(', '))
      end
    end

    def get_account_name
      print Message::Prompt.account_name
      STDIN.gets.chomp
    end

    def get_username
      print Message::Prompt.username(account)
      STDIN.gets.chomp
    end

    def get_length
      print Message::Prompt.password_length
      length = STDIN.gets.chomp.to_i
      length == 0 ? 12 : length
    end
end
