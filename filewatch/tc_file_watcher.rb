require 'test/unit'
require_relative 'file_command_parser'
require_relative 'file_watcher'

class TestArithmetic < Test::Unit::TestCase

	def test_missing_options
      # -f is missing
      assert_raise ArgumentError do
        file_watcher = FileWatcher.new(["-t", "3", "-c", "ls"])
      end

      # -dac is missing
      assert_raise ArgumentError do
        file_watcher = FileWatcher.new(["-t", "3", "-f", "file1"])
      end

      # -t is missing, no error should be thrown
      assert_nothing_raised ArgumentError do
        file_watcher = FileWatcher.new(["-f", "file1", "-c", "ls"])
      end

  end

  def test_multiple_options

      # Multiple -fs
      assert_raise ArgumentError do
        file_watcher = FileWatcher.new(["-f", "file1", "-t", "3", "-c", "ls", "-f", "file1"])
      end

      # Multiple -t
      assert_raise ArgumentError do
        file_watcher = FileWatcher.new(["-f", "file1", "-t", "3", "-c", "ls", "-t", "0"])
      end

      # Multiple -ds
      assert_raise ArgumentError do
        file_watcher = FileWatcher.new(["-f", "file1", "-t", "3", "-d", "ls", "-d", "ls"])
      end

      # Multiple -cs
      assert_raise ArgumentError do
        file_watcher = FileWatcher.new(["-f", "file1", "-t", "3", "-c", "ls", "-c", "ls"])
      end

      # Multiple -cs
      assert_raise ArgumentError do
        file_watcher = FileWatcher.new(["-f", "file1", "-t", "3", "-a", "ls", "-a", "ls"])
      end

      # -da
      assert_raise ArgumentError do
        file_watcher = FileWatcher.new(["-f", "file1", "-t", "3", "-d", "ls", "-a", "ls"])
      end

      # -dc
      assert_raise ArgumentError do
        file_watcher = FileWatcher.new(["-f", "file1", "-t", "3", "-d", "ls", "-c", "ls"])
      end

      # -ac
      assert_raise ArgumentError do
        file_watcher = FileWatcher.new(["-f", "file1", "-t", "3", "-a", "ls", "-c", "ls"])
      end

  end

  def test_other_options
    assert_raise ArgumentError do
      file_watcher = FileWatcher.new(["-f", "file1", "-t", "3", "-c", "ls", "-e"])
    end
  end

  def test_no_arguments

  end

  def test_multiple_times_given

  end

  def test_valid_time_given

  end

  def test_any_option_order_allowed

  end

  def test_c_file_creation

  end

  def test_c_folder_creation

  end

  def test_c_multiple_files

  end

  def test_c_file_destruction_then_creation

  end

  def test_c_folder_destruction_then_creation

  end

  def test_d_file_destruction

  end

  def test_d_folder_destruction

  end

  def test_d_multiple_files

  end

  def test_d_file_creation_then_destruction

  end

  def test_d_folder_creation_then_destruction

  end

  def test_a_file_creation

  end

  def test_a_folder_creation

  end

  def test_a_multiple_files

  end

  def test_a_file_destruction

  end

  def test_a_folder_destruction

  end

  def test_a_nested_folder_creation_and_destruction

  end

  def test_a_nested_file_creation_and_destruction

  end

  def test_a_file_modification

  end

  def test_a_file_rename

  end

  def test_a_nested_file_modification

  end

  def test_a_nested_file_rename

  end

  def test_a_nested_folder_rename

  end

end
