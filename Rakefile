require 'rake'

namespace :test do
  desc 'Run all tests in test suite, including FileIO'
  task :all do
    Dir.glob('./test/*_test.rb').each { |file| require file}
  end

  desc 'Run all tests except FileIO'
  task :core do
    ENV['s'] = 'skip'
    Dir.glob('./test/*_test.rb').each { |file| require file}
  end

  desc 'Run RyPass in test environment'
  task :rypass do
    PATH = File.expand_path('.')
    require './config/setup'
    print '$rypass '
    ARGV = STDIN.gets.chomp.split(' ')
    begin
      params = Exec.set_params
      params[:destination] = File.expand_path('./tmp')
      params[:path] = File.expand_path('./tmp')
      if params[:action] == :display_commands
        Exec.send(params[:action])
      elsif params[:action] == :uninstall
        puts "\nERROR: Can't uninstall in TEST environment."
      elsif params[:action]
        Exec.send(params[:action], params)
      end
    rescue Interrupt
      puts "\nThank you for using RyPass"
      exit
    end
  end
end
