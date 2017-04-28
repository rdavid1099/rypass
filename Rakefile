PATH = File.expand_path('.')
require 'rake'
require_relative './config/setup'

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
    ARGV.shift
    begin
      params = Exec.set_params
      if params[:action] == :uninstall || params[:action] == :display_commands
        Exec.send(params[:action])
      elsif params[:action]
        Exec.send(params[:action], params)
      end
    rescue Interrupt
      puts "\nThank you for using RyPass"
      exit
    end
  end
end
