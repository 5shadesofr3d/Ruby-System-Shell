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

end
