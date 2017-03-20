require './test/test_helper'

class FileItTest < TestHelper
  def test_it_parses_params_properly_using_index_number
    set_ARGV_values('n', '-a', 'test', '--username=tester', '-l', '15', '--fake=?', '--path=~/path/to/csv')
    index = Exec.sort_params(1)
    assert_equal index, 3

    new_index = Exec.sort_params(3)
    assert_equal new_index, 4
  end

  def test_it_sets_proper_params_dependent_on_ARGV
    set_ARGV_values('n', '-a', 'test', '--username=tester', '-l', '15', '--fake=?', '--path=~/path/to/csv')
    params = Exec.set_params

    assert_equal params[:action], :new_account
    assert_equal params[:account], 'test'
    assert_equal params[:username], 'tester'
    assert_equal params[:length], 15
    assert_equal params[:destination], '~/path/to/csv'
    assert_nil params[:fake]
  end
end
