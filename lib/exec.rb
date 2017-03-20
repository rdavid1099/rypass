require './config/setup'

class Exec
  def self.new_account(params)
    gen = Generator.new
    password = gen.create_new_account(params)
    puts "\n" + Message::Statement.success(password)
    raise Interrupt
  end

  def self.generate

  end

  def self.display_account

  end

  def self.set_params
    @params = Hash[action: dictionary[ARGV.first]]
    i = 1
    while i < ARGV.length do
      i = sort_params(i)
    end
    @params
  end

  def self.sort_params(i)
    if ARGV[i].include?('--')
      parse_params(ARGV[i])
      i += 1
    else
      @params[dictionary[ARGV[i]]] = ARGV[i+1].to_i.zero? ? ARGV[i+1] : ARGV[i+1].to_i
      i += 2
    end
  end

  def self.parse_params(params)
    split_params = params.split('=')
    @params[dictionary[split_params[0]]] = split_params[1] if dictionary.keys.include?(split_params[0])
  end

  private
    def self.dictionary
      {
        'n' => :new_account, 'new' => :new_account,
        'g' => :generate, 'generate' => :generate,
        'a' => :display_account, 'account' => :display_account,
        '-a' => :account, '--account' => :account,
        '-u' => :username, '--username' => :username,
        '-p' => :destination, '--path' => :destination,
        '-l' => :length, '--length' => :length
      }
    end
end
