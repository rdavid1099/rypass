require "#{PATH}/config/setup"

# Executes all functionality called by RyPass terminal commands
class Exec

  # Create a new account to be saved with a username and generated password
  #
  # @param [Hash] params the parameters used to create the new account
  # @option params [String] :destination ('~/Library/RyPass') the pathname where the account csv will be saved
  # @option params [String] :account the name of the account
  # @option params [String] :username the name of the username to be saved to the account
  # @option params [Integer] :length the length of the generated password
  # @raise [RuntimeError] if username is already taken for given account, the length of generated password is too large, or data could not be saved
  # @raise [Interrupt] closes program after execution is complete
  def self.new_account(params)
    begin
      generator = Generator.new(params[:destination])
      saved_meta_data = generator.create_new_account(params)
      puts "\n" + Message::Statement.success(saved_meta_data)
    rescue RuntimeError => e
      puts e
    ensure
      raise Interrupt
    end
  end

  # Generate random password which is not connected to an account or username
  #
  # @param [Hash] params the parameters used to generate a password
  # @option params [Integer] :length the length of the generated password
  # @raise [Interrupt] closes program after execution is complete
  def self.generate(params)
    password = Password.new.generate_new(params[:length] || 12)
    puts "\n" + Message::Statement.password_generated(password)
    if save_to_existing?
      Generator.new.save_password(password)
      puts "\n" + Message::Statement.success(password)
    end
    raise Interrupt
  end

  # Display specified information related to given account
  #
  # @param [Hash] params the parameters used to find necessary account information
  # @option params [String] :account the name of the account
  # @option params [String] :destination ('~/Library/RyPass') the pathname where the account csv will be loaded
  # @option params [String] :username the username to be loaded with the associated account
  # @option params [Symbol] :second_action (:all) the action the account is displaying (:all, :usernames, :get_password)
  # @raise [RuntimeError] if an invalid display command is passed through
  # @raise [Interrupt] closes program after execution is complete
  def self.display_account(params)
    begin
      account = Account.new(params)
      puts "\n" + account.send(params[:second_action])
    rescue RuntimeError => e
      puts e
    ensure
      raise Interrupt
    end
  end

  # Export account csvs to a different location
  #
  # @param [Hash] params the parameters used to export data
  # @option params [String] :account (nil) the name of the account to be exported, if no account name is given it will export all accounts
  # @option params [String] :destination the destination path where the data will be exported
  # @option params [String] :path ('~/Library/RyPass') the path where the data is stored and will be loaded
  # @raise [RuntimeError] if a given destination is invalid or not given
  # @raise [Interrupt] closes program after execution is complete
  def self.export(params)
    begin
      Exporter.new(params).export
      puts Message::Statement.export_successful(params[:destination])
    rescue => e
      puts e
    ensure
      raise Interrupt
    end
  end

  # Executes ./config/uninstall.sh and removes RyPass from computer
  def self.uninstall
    `#{File.expand_path('~')}/RyPassSource/config/uninstall.sh`
    puts Message::Statement.uninstalled
  end

  # Prints all RyPass commands to the screen
  #
  # @raise [Interrupt] closes program after execution is complete
  def self.display_commands
    puts Message::Statement.command_list
    raise Interrupt
  end

  # Parses environment arguments passed in through the terminal and formats them into a readable hash
  #
  # @return [Hash] params ordered in a hash that RyPass can read and execute
  def self.set_params
    @params = Hash[action: actionary[ARGV.first]]
    i = determine_secondary_actions
    while i < ARGV.length do
      i = sort_params(i)
    end
    @params
  end

  # Parses environment arguments if a secondary action is given
  #
  # @return [Integer] 1 or 2 depending on the index of the next environment argument and if a secondary action was given
  def self.determine_secondary_actions
    if @params[:action] == :display_account && actionary.keys.include?(ARGV[1])
      @params[:second_action] = actionary[ARGV[1]]
      return 2
    elsif @params[:action] == :display_account
      @params[:second_action] = :all
    end
    1
  end

  # Parse single environment argument to determine if it is formatted with '--' or '-'
  #
  # @return [Integer] the index of the next environment argument
  def self.sort_params(i)
    if ARGV[i].include?('--')
      parse_params(ARGV[i])
      i += 1
    else
      @params[dictionary[ARGV[i]]] = ARGV[i+1].to_i.zero? ? ARGV[i+1].downcase : ARGV[i+1].to_i
      i += 2
    end
  end

  # Parse environment argument formatted with '--' and adds it to the params Hash
  def self.parse_params(params)
    split_params = params.split('=')
    @params[dictionary[split_params[0]]] = split_params[1] if dictionary.keys.include?(split_params[0])
  end

  # Prompt user to save randomly generated password to an existing account
  #
  # @return [Boolean] true if user answers 'yes' or 'y', false if user answers 'no' or 'n'
  def self.save_to_existing?
    response = ''
    until response[0] == 'y' || response[0] == 'n'
      print Message::Prompt.save_to_existing
      response = STDIN.gets.downcase.chomp
    end
    response[0] == 'y' ? true : false
  end

  private
    def self.dictionary
      {
        '-a' => :account, '--account' => :account,
        '-u' => :username, '--username' => :username,
        '-d' => :destination, '--destination' => :destination,
        '-l' => :length, '--length' => :length,
        '-p' => :path, '--path' => :path
      }
    end

    def self.actionary
      {
        'n' => :new_account, 'new' => :new_account,
        'g' => :generate, 'generate' => :generate,
        'a' => :display_account, 'account' => :display_account,
        'e' => :export, 'export' => :export,
        'U' => :uninstall, 'uninstall' => :uninstall,
        'c' => :display_commands, 'commands' => :display_commands,
        '-A' => :all, '--all' => :all,
        '-U' => :usernames, '--usernames' => :usernames,
        '-P' => :get_password, '--get-password' => :get_password
      }
    end
end
