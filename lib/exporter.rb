require './config/setup'

class Exporter
  attr_reader :destination, :path, :account

  def initialize(**args)
    @destination = set_path(args[:destination])
    @path = set_path(args[:path])
    @account = args[:account]
  end

  def export_account(exporting_account = nil)
    exporting_account ||= account
    CSV.open("#{destination}/export-#{exporting_account}.csv", 'wb') do |csv|
      CSV.foreach("#{path}/#{exporting_account}.csv") { |row| csv << row }
    end
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
