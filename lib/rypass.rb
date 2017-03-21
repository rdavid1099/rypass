require './config/setup'

begin
  params = Exec.set_params
  Exec.send(params[:action], params) if params[:action]
rescue Interrupt
  puts "\nThank you for using RyPass"
  exit
end
