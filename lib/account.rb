require './config/setup'

class Account
  attr_reader :name, :destination

  def initialize(**args)
    @name = args[:name]
    @destination = args[:destination] || File.expand_path('~/Library/RyPass')
    load_csv
  end

  def usernames
    raw_data.keys
  end

  def get_password(username)
    raw_data[username]
  end

  def all
    raw_data.to_a
  end

  private
    attr_reader :raw_data

    def load_csv
      if Dir["#{destination}/*.csv"].include?("#{destination}/#{name}.csv")
        @raw_data = {}
        CSV.foreach("#{destination}/#{name}.csv", headers: true) do |row|
          @raw_data[row[0]] = row[1] unless row[0] == 'username'
        end
      else
        raise RuntimeError, "Account '#{name}' not found in directory '#{destination}'"
      end
    end
end
