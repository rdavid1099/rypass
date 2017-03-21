require './config/setup'

class Exec
  def self.new_account(params)
    password = Generator.new.create_new_account(params)
    puts "\n" + Message::Statement.success(password)
    raise Interrupt
  end

  def self.generate(params)
    password = Password.new.generate_new(params[:length] || 12)
    puts "\n" + Message::Statement.password_generated(password)
    if save_to_existing?
      Generator.new.save_password(password)
      puts "\n" + Message::Statement.success(password)
    end
    raise Interrupt
  end

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

  def self.set_params
    @params = Hash[action: actionary[ARGV.first]]
    i = determine_secondary_actions
    while i < ARGV.length do
      i = sort_params(i)
    end
    @params
  end

  def self.determine_secondary_actions
    if @params[:action] == :display_account && actionary.keys.include?(ARGV[1])
      @params[:second_action] = actionary[ARGV[1]]
      return 2
    elsif @params[:action] == :display_account
      @params[:second_action] = :all
    end
    1
  end

  def self.sort_params(i)
    if ARGV[i].include?('--')
      parse_params(ARGV[i])
      i += 1
    else
      @params[dictionary[ARGV[i]]] = ARGV[i+1].to_i.zero? ? ARGV[i+1].downcase : ARGV[i+1].to_i
      i += 2
    end
  end

  def self.parse_params(params)
    split_params = params.split('=')
    @params[dictionary[split_params[0]]] = split_params[1] if dictionary.keys.include?(split_params[0])
  end

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
        '-A' => :all, '--all' => :all,
        '-U' => :usernames, '--usernames' => :usernames,
        '-P' => :get_password, '--get-password' => :get_password
      }
    end
end
