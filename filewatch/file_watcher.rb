require_relative 'file_command_parser'
require_relative '../precision/precision'
require_relative '../shell/command'
require 'test/unit'

class FileWatcher
	include Test::Unit::Assertions

	def initialize(args)
		#pre
		assert args.is_a? Array
		args.each { |a| assert a.is_a? String }

		parser = FileCommandParser.new(args)

		@command = parser.command[0]
		@args = parser.command[1]
		@delay = parser.delay
		alteration = parser.monitor_type

		if alteration == "-d"
			@alteration = "file_destroyed?"
			#alteration = "destroyed"
		elsif alteration == "-a"
			@alteration = "file_changed?"
			#alteration = "altered"
		else
			@alteration = "file_created?"
			#alteration = "created"
		end

		@observers = self.create_observer(parser.files)

		#post
		assert @command.is_a? String
		assert @delay.is_a? Numeric
		assert @delay >= 0
		assert @observers.is_a? Array
		@observers.each {|o| assert o.is_a? Observer}
		assert @alteration.is_a? String
		assert valid?
	end

	def observers
		assert valid?

		return @observers
	end

	def valid?
		return false unless @command.is_a? String
		return false unless @delay.is_a? Numeric
		return false unless @alteration.is_a? String
		return false unless @observers.is_a? Array
		@observers.each { |file| return false unless file.is_a? Observer }

		return true
	end

	def create_observer(files)
		#pre
		assert files.is_a? Array
		files.each { |f| assert f.is_a? String }

		watchList = []
		for file in files
			watchList += [Observer.new(file)]
		end

		#post
		assert watchList.is_a? Array
		watchList.each { |f| assert f.is_a? Observer }
		return watchList
	end

	def watch
		#pre
		assert valid?
		assert @observers.is_a? Array
		@observers.each {|o| assert o.is_a? Observer}
		assert @alteration.is_a? String
		assert @command.is_a? String
		assert @delay.is_a? Numeric
		assert @delay >= 0

		while true
			for observer in @observers
				if observer.send(@alteration)
					puts "The file '#{observer.file}' was #{@alteration}... the command '#{@command}' will execute in #{@delay} milliseconds..."
					Precision::timer_ms(@delay, ForkCommand.new { self.exec_command } )
				end
			end
		end

		#post
	end

	def exec_command
		#pre
		assert valid?
		#assert (@args.is_a? String) || (@args.is_a? NIL) try this out when applicable tests exist
		assert @command.is_a? String

		if @args.is_a? String
			exec(@command, @args)
		else
			exec(@command)
		end

		#post
		assert valid?
	end
end


class Observer
	include Test::Unit::Assertions
	def initialize(file)
		#pre
		assert file.is_a? String

		@file = file
		@time_altered = self.calculate_last_altered_time
		@exists = self.calculate_file_exists

		#post
		assert @file.is_a? String
		assert @time_altered.is_a? Time
		assert (@exists == true || @exists == false)
		assert valid?
	end

	def file
		#pre
		assert valid?
		assert @file.is_a? String

		return @file
	end

	def exists
		assert valid?
		return @exists
	end

	def time_altered
		assert valid?
		return @time_altered
	end

	def valid?
		return false unless (@exists == true || @exists == false)
		return false unless @file.is_a? String
		return false unless @time_altered.is_a? Time
		return true
	end

	def calculate_last_altered_time
		#dont assert class invariant as this is called during setup
		# pre
		assert @file.is_a? String

		begin
				aTime = File.stat(@file).atime
			rescue
				aTime = Time.new(0)
		end

		#post
		assert aTime.is_a? Time
		return aTime
	end

	def calculate_file_exists
		#dont assert class invariant as this is called during setup
		# pre
		assert @file.is_a? String

		doesFileExist = true
		begin
			File::Stat.new(@file)
		rescue
			doesFileExist = false
		end

		#post
		assert (doesFileExist == true || doesFileExist == false)
		return doesFileExist
	end

	def file_created?
		#pre
		assert valid?
		assert (@exists == true || @exists == false)

		oldExistsStatus = @exists
		@exists = self.calculate_file_exists

		#post
		assert (@exists == true || @exists == false)
		assert (oldExistsStatus == true || oldExistsStatus == false)
		assert valid?
		if @exists and !oldExistsStatus
			return true
		end
		return false
	end

	def file_destroyed?
		#pre
		assert valid?
		assert (@exists == true || @exists == false)

		oldExistsStatus = @exists
		@exists = self.calculate_file_exists

		#post
		assert valid?
		assert (@exists == true || @exists == false)
		assert (oldExistsStatus == true || oldExistsStatus == false)
		if !@exists and oldExistsStatus
			return true
		end
		return false
	end

	def file_changed?
		#pre
		assert valid?
		assert @time_altered.is_a? Time

		oldTime = @time_altered
		@time_altered = self.calculate_last_altered_time

		#post
		assert valid?
		assert @time_altered.is_a? Time
		assert oldTime.is_a? Time
		# No change
		if oldTime == @time_altered
			return false
		else
			return true
		end
	end
end
