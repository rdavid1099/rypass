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
end
