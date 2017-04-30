require "#{PATH}/config/setup"

# Handles file saving and destroying functionality for RyPass
class FileIt
  # @return [String] the destination of the file being saved or destroyed
  attr_reader :destination

  # @return [Array] list of errors collected if any errors occurred during the saving or destroying process
  attr_reader :errors

  # Initialize FileIt with a destination
  #
  # @param [String] destination the path where all data will be saved or destroyed - defaults to nil which is then memoized to '~/Library/RyPass'
  def initialize(destination = nil)
    @errors = []
    destination ||= '~/Library/RyPass'
    @destination = File.expand_path(destination)
    create_directory unless File.exists?(@destination)
    @encrypt = Encryption.new
  end

  # Save or update data for given account name
  #
  # @param [Hash] options the options for saving an account
  # @option options [String] :account name of the account being saved or updated
  # @option options [String] :username username for the given account
  # @option options [String] :password generated password for the given account
  # @return [Boolean] true if account successfully saved or updated, false if an error occurred
  def save(**options)
    result = if account_exists?(options[:account])
      update_existing_account(options)
    else
      create_new_account(options)
    end
    result
  end

  # Destroy data for given account name
  #
  # @param [Hash] options the options for destroying an account
  # @option options [String] :account name of the account being destroyed
  # @option options [String] :username username for the given account
  # @option options [String] :password generated password for the given account
  # @return [Boolean] true if account was successfully destroyed, false if account could not be found
  def destroy(**options)
    if account_exists?(options[:account])
      update_existing_account(options, destroy: true)
    else
      false
    end
  end

  # Checks to see if account name exists
  #
  # @param [String] account account name searching for in :destination
  # @return [Boolean] true if account is found at :destination, false if account is not found
  def account_exists?(account)
    Dir["#{destination}/*.csv"].include?("#{destination}/#{account}.csv")
  end

  private
    attr_reader :encrypt

    def create_directory
      FileUtils::mkdir_p destination
    end

    def update_existing_account(data, destroy: nil)
      CSV.open("#{destination}/new-#{data[:account]}.csv", 'wb') do |csv|
        CSV.foreach("#{destination}/#{data[:account]}.csv") do |row|
          csv << row unless row[0] == data[:username]
        end
        unless destroy
          csv << [data[:username],
                  encrypt.encrypt_password(data[:password]),
                  encrypt.nonce]
        end
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
        csv << ['username', 'password', 'nonce']
        csv << [options[:username],
                encrypt.encrypt_password(options[:password]),
                encrypt.nonce]
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
