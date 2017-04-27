require './test/test_helper'

class ExporterTest < TestHelper
  def test_exporter_takes_in_custom_path_and_destination
    file_io_test
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
    file_io_test
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

  def test_exporter_sets_up_for_mass_export
    file_io_test
    exporter = Exporter.new(path: '~', destination: '.')
    exporter.set_up_destination_for_mass_export

    assert File.exists?(File.expand_path('./RyPass'))
    clean_exported_csvs
  end

  def test_exporter_exports_all_accounts_to_folder_rypass_at_destination_if_no_account_given
    file_io_test
    generate_test_account(2)
    generate_test_account(3, 'this-test')
    exporter = Exporter.new(path: '~/Library/RyPass/test', destination: '.')
    exporter.export

    assert File.exists?(File.expand_path('./RyPass/export-test.csv'))
    assert File.exists?(File.expand_path('./RyPass/export-this-test.csv'))
    clean_test_csvs
    clean_exported_csvs
  end
end
