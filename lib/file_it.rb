require './config/setup'

class FileIt
  attr_reader :destination, :errors

  def initialize(destination = nil)
    @errors = []
    @current_path = `pwd`.chomp
    destination ||= '~/Library/RyPass'
    @destination = File.expand_path(destination)
    create_directory unless File.exists?(@destination)
  end

  def save(**options)
    result = if account_exists?(options[:account])
      update_existing_account(options)
    else
      create_new_account(options)
    end
    result
  end

  def destroy(**options)
    if account_exists?(options[:account])
      update_existing_account(options, destroy: true)
    else
      false
    end
  end

  def account_exists?(account)
    Dir["#{destination}/*.csv"].include?("#{destination}/#{account}.csv")
  end

  private
    attr_reader :current_path

    def create_directory
      Dir.chdir('/')
      FileUtils::mkdir_p destination
      Dir.chdir(current_path)
    end

    def update_existing_account(data, **options)
      CSV.open("#{destination}/new-#{data[:account]}.csv", 'wb') do |csv|
        CSV.foreach("#{destination}/#{data[:account]}.csv") do |row|
          csv << row unless row[0] == data[:username]
        end
        csv << [data[:username], data[:password]] unless options[:destroy]
      end
      clean_and_rename_new_csv(data[:account])
      true
    rescue => e
      @errors << e
      @errors << 'Username and/or password did not update'
      false
    end

    def create_new_account(options)
      CSV.open("#{destination}/#{options[:account]}.csv", 'wb') do |csv|
        csv << ['username', 'password']
        csv << [options[:username], options[:password]]
      end
      true
    rescue => e
      @errors << e
      @errors << 'Username and/or password did not save'
      false
    end

    def clean_and_rename_new_csv(account)
      FileUtils.rm("#{destination}/#{account}.csv")
      File.rename("#{destination}/new-#{account}.csv",
                  "#{destination}/#{account}.csv")
    end
end
