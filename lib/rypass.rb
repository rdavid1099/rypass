require './config/setup'

class Rypass
  Exec.new_account if ARGV.first == 'n' || ARGV.first == 'new'
  Exec.generate if ARGV.first == 'g' || ARGV.first == 'generate'
  Exec.account if ARGV.first == 'a' || ARGV.first == 'account'
end
