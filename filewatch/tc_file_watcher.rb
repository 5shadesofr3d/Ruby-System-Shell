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

end
