require './config/setup'

class Exec
  def self.new_account
    gen = Generator.new
    puts gen.create_new_account(account: ARGV[1],
                                    username: ARGV[2],
                                    length: ARGV[3])
  end

  def self.generate

  end

  def self.account

  end
end
