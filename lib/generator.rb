require './config/setup'

class Generator
  attr_reader :username, :account

  def initialize(**options)
    @password_klass = Password.new
    @file_it = FileIt.new(options[:path])
    @username = options[:username]
    @account = options[:account]
  end

  def create_new_account(**options)
    @account = options[:account] || get_account_name
    @username = options[:username] || get_username
    @password = generate_password options[:length] || get_length
    save_information
  end

  def create_new_user(new_username)
    if username
      puts Message::Error.username_exists(username)
    else
      @username = new_username
      generate_password
    end
  end

  def find_all_users_for_account(account_query)
    if account == account_query
      [username]
    else
      puts Message::Error.account_not_found(account_query)
    end
  end

  def find_account_for_user(name_query)
    if name_query == username
      account
    else
      puts Message::Error.username_not_found(name_query)
    end
  end

  def find_password_for_user(name_query)
    if name_query == username
      password
    else
      puts Message::Error.username_not_found(name_query)
    end
  end

  def generate_password(length = 12)
    password_klass.generate_new(length)
  rescue
    puts Message::Error.too_many_characters
  end

  private
    attr_reader :password_klass, :file_it, :password

    def save_information
      if file_it.save(account: account.downcase, username: username.downcase, password: password)
        password
      else
        Message::Error.general(file_it.errors.join(', '))
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
