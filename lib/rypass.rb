require './config/setup'

begin
  params = Exec.set_params
  # set_variables
  Exec.new_account if ARGV.first == 'n' || ARGV.first == 'new'
  Exec.generate if ARGV.first == 'g' || ARGV.first == 'generate'
  Exec.account if ARGV.first == 'a' || ARGV.first == 'account'
rescue Interrupt
  puts "\nThank you for using RyPass"
  exit
end
