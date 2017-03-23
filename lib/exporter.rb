require "#{PATH}/config/setup"

class Exporter
  attr_reader :destination, :path, :account

  def initialize(**args)
    @destination = set_path(args[:destination])
    args[:path] ||= '~/Library/RyPass'
    @path = set_path(args[:path])
    @account = args[:account]
  end

  def export
    if account.nil?
      set_up_destination_for_mass_export
      export_all
    else
      export_account
    end
  end

  def export_all
    Dir.glob("#{path}/*.csv").each do |file|
      account_name = file.split('/').last.sub('.csv','')
      export_account(account_name)
    end
  end

  def export_account(exporting_account = nil)
    exporting_account ||= account
    CSV.open("#{destination}/export-#{exporting_account}.csv", 'wb') do |csv|
      CSV.foreach("#{path}/#{exporting_account}.csv") { |row| csv << row }
    end
  end

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
