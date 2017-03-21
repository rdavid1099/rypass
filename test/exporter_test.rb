require './test/test_helper'

class ExporterTest < TestHelper
  def test_exporter_takes_in_custom_path_and_destination
    generate_test_account
    exporter = Exporter.new(path: '~/Library/RyPass/test', destination: '.')
    clean_test_csvs

    assert exporter.path.include?('/Library/RyPass/test')
    assert exporter.destination.include?('password-generator')
  end

  def test_exporter_crashes_if_either_path_does_not_exist
    begin
      Exporter.new(path: '~/not/real/path', destination: '.')
    rescue => e
      assert_instance_of RuntimeError, e
    end
  end

  def test_exporter_copies_account_csv_to_destination
    generate_test_account
    exporter = Exporter.new(path: '~/Library/RyPass/test', destination: '.', account: 'test')
    exporter.export_account
    csv = load_csv
    exported_csv = load_exported_csv
    clean_test_csvs
    clean_exported_csvs

    assert_equal exported_csv[:username], csv[:username]
    assert_equal exported_csv[:password], csv[:password]
  end
end
