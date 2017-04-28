require "#{PATH}/config/setup"

# Handles all exporting functionality of RyPass
class Exporter
  # @return [String] the destination of exported data
  attr_reader :destination

  # @return [String] the path of the data to be exported
  attr_reader :path

  # @return [String] the account to be exported if given when initialized
  attr_reader :account

  # Initialize Exporter with a hash of options
  #
  # @param [Hash] args the options to create an account with
  # @option args [String] :account (nil) the name of the account to be exported, if no account name is given it will export all accounts
  # @option args [String] :destination the destination path where the data will be exported
  # @option args [String] :path ('~/Library/RyPass') the path where the data is stored and will be loaded
  # @raise [RuntimeError] if :path or :destination are not valid paths
  def initialize(**args)
    @destination = set_path(args[:destination])
    args[:path] ||= '~/Library/RyPass'
    @path = set_path(args[:path])
    @account = args[:account]
  end

  # Export account data if account name was given when initialized, else it exports all accounts data
  def export
    if account.nil?
      set_up_destination_for_mass_export
      export_all
    else
      export_account
    end
  end

  # Exports all accounts data from :path to :destination
  def export_all
    Dir.glob("#{path}/*.csv").each do |file|
      account_name = file.split('/').last.sub('.csv','')
      export_account(account_name)
    end
  end

  # Export specific account data from :path to :destination
  #
  # @param [String] exporting_account name of account to be exported
  def export_account(exporting_account = nil)
    exporting_account ||= account
    CSV.open("#{destination}/export-#{exporting_account}.csv", 'wb') do |csv|
      CSV.foreach("#{path}/#{exporting_account}.csv") { |row| csv << row }
    end
  end

  # Create folder '/RyPass' at :destination to export all accounts data to
  def set_up_destination_for_mass_export
    @destination += '/RyPass'
    FileUtils.mkdir_p destination
  end

  private
    def set_path(path)
      path = path.nil? ? '' : File.expand_path(path)
      if File.exists?(path)
        path
      else
        raise RuntimeError, Message::Error.path_not_found(path)
      end
    end
end
