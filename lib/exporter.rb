require './config/setup'

class Exporter
  attr_reader :destination, :path

  def initialize(**args)
    @destination = set_path(args[:destination])
    @path = set_path(args[:path])
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
