require './test/test_helper'

class ExporterTest < TestHelper
  def test_exporter_takes_in_custom_path_and_destination
    generate_test_account
    exporter = Exporter.new(destination: '~/Library/RyPass/test', path: '.')

    assert exporter.destination.include?('/Library/RyPass/test')
    assert exporter.path.include?('password-generator')
  end
end
