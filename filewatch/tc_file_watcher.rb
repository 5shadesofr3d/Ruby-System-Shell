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
    # -f missing
    assert_raise ArgumentError do
      file_watcher = FileWatcher.new(["-f", "-t", "3", "-c", "ls"])
    end

    # -t missing
    assert_raise ArgumentError do
      file_watcher = FileWatcher.new(["-f", "file1", "-t", "-c", "ls"])
    end

    # -d missing
    assert_raise ArgumentError do
      file_watcher = FileWatcher.new(["-f", "file1", "-t", "3", "-d"])
    end

    # -a missing
    assert_raise ArgumentError do
      file_watcher = FileWatcher.new(["-f", "file1", "-t", "3", "-a"])
    end

    # -c missing
    assert_raise ArgumentError do
      file_watcher = FileWatcher.new(["-f", "file1", "-t", "3", "-c"])
    end

  end

  def test_multiple_times_given
    # Two values given
    assert_raise ArgumentError do
      file_watcher = FileWatcher.new(["-f", "file1", "-t", "3", "6", "-c", "ls"])
    end
  end

  def test_valid_time_given
    # Edge cases...
    assert_nothing_raised ArgumentError do
      file_watcher = FileWatcher.new(["-f", "file1", "-t", "0", "-c", "ls"])
    end

    assert_nothing_raised ArgumentError do
      file_watcher = FileWatcher.new(["-f", "file1", "-t", "600", "-c", "ls"])
    end

    # Negative
    assert_raise ArgumentError do
      file_watcher = FileWatcher.new(["-f", "file1", "-t", "-1", "-c", "ls"])
    end

    # Non number
    assert_raise ArgumentError do
      file_watcher = FileWatcher.new(["-f", "file1", "-t", "a", "-c", "ls"])
    end

  end

  def test_any_option_order_allowed
    #file_watcher = FileWatcher.new(["-f", "file1", "-t", "3", "-c", "ls"])
    # -f, -t, -dac
    assert_nothing_raised ArgumentError do
      file_watcher = FileWatcher.new(["-f", "file1", "-t", "3", "-c", "ls"])
    end

    # -f, -dac, -t
    assert_nothing_raised ArgumentError do
      file_watcher = FileWatcher.new(["-f", "file1", "-a", "ls", "-t", "3"])
    end

    # -dac, -f, -t
    assert_nothing_raised ArgumentError do
      file_watcher = FileWatcher.new(["-d", "ls", "-f", "file1", "-t", "3"])
    end

    # -dac, -t, -f
    assert_nothing_raised ArgumentError do
      file_watcher = FileWatcher.new(["-a", "ls", "-t", "3", "-f", "file1"])
    end

    # -t, -dac, -f
    assert_nothing_raised ArgumentError do
      file_watcher = FileWatcher.new(["-t", "3", "-c", "ls",  "-f", "file1"])
    end

    # -t, -f, -dac
    assert_nothing_raised ArgumentError do
      file_watcher = FileWatcher.new(["-t", "3", "-f", "file1", "-d", "ls"])
    end

  end

  def test_c_file_creation

    file_watcher = FileWatcher.new(["-f", "testFile", "-t", "3", "-c", "ls"])
		file_watcher.testMode

		# File should not be created yet
		assert(!file_watcher.observers[0].exists)

		# Create file
		system("touch testFile")

		# Monitor for file change, because of test mode it will exit
		file_watcher.watch

		# File should be created and observed
		assert(file_watcher.observers == true)

		system("rm testFile")

  end

  def test_c_folder_creation

		file_watcher = FileWatcher.new(["-f", "testFolder", "-t", "3", "-c", "ls"])
		file_watcher.testMode

		# File should not be created yet
		assert(!file_watcher.observers[0].exists)

		# Create file
		system("mkdir testFolder")

		# Monitor for file change, because of test mode it will exit
		file_watcher.watch

		# File should be created and observed
		assert(file_watcher.observers == true)

		system("rmdir testFolder")

  end

  def test_c_multiple_files
		file_watcher = FileWatcher.new(["-f", "testFolder", "testFile",  "-t", "3", "-c", "ls"])
		file_watcher.testMode

		# File and folder should not be created yet
		assert(!file_watcher.observers[0].exists)
		assert(!file_watcher.observers[1].exists)

		# Create file
		system("mkdir testFolder")
		system("touch testFile")

		# Monitor for file change, because of test mode it will exit
		file_watcher.watch

		# File should be created and observed
		assert(file_watcher.observers == true)

		system("rmdir testFolder")
		system("rm testFile")

  end

  def test_d_file_destruction
		# Create file
		system("touch testFile")

		file_watcher = FileWatcher.new(["-f", "testFile", "-t", "3", "-d", "ls"])
		file_watcher.testMode

		# File should be created
		assert(file_watcher.observers[0].exists)

		system("rm testFile")

		# Monitor for file change, because of test mode it will exit
		file_watcher.watch

		# File should be destroyed and observed
		assert(file_watcher.observers == true)

  end

  def test_d_folder_destruction
		# Create file
		system("mkdir testFolder")

		file_watcher = FileWatcher.new(["-f", "testFolder", "-t", "3", "-d", "ls"])
		file_watcher.testMode

		# File should be created
		assert(file_watcher.observers[0].exists)

		system("rmdir testFolder")

		# Monitor for file change, because of test mode it will exit
		file_watcher.watch

		# File should be destroyed and observed
		assert(file_watcher.observers == true)

  end

  def test_d_multiple_files
		# Create file
		system("mkdir testFolder")
		system("touch testFile")

		file_watcher = FileWatcher.new(["-f", "testFolder", "testFile", "-t", "3", "-d", "ls"])
		file_watcher.testMode

		# File should be created
		assert(file_watcher.observers[0].exists)
		assert(file_watcher.observers[1].exists)

		system("rmdir testFolder")
		system("rm testFile")

		# Monitor for file change, because of test mode it will exit
		file_watcher.watch

		# File should be destroyed and observed
		assert(file_watcher.observers == true)
		
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
