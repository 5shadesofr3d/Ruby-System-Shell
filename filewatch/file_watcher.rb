require_relative 'file_command_parser'
require_relative '../precision/precision'
require_relative '../shell/command'

class FileWatcher
	def initialize(args)
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
	end

	def create_observer(files)
		watchList = []
		for file in files
			watchList += [Observer.new(file)]
		end
		return watchList
	end

	def watch
		while true
			for observer in @observers
				if observer.send(@alteration)
					puts "The file '#{observer.file}' was #{@alteration}... the command '#{@command}' will execute in #{@delay} milliseconds..."
					Precision::timer_ms(@delay, ForkCommand.new { self.exec_command } )
				end
			end
		end
	end

	def exec_command
		if @args.is_a? String
			exec(@command, @args)
		else
			exec(@command)
		end
	end

end


class Observer
	def initialize(file)
		@file = file
		@time_altered = self.calculate_last_altered_time
		@exists = self.calculate_file_exists

	end

	def file
		return @file
	end

	def calculate_last_altered_time
		begin
			aTime = File.stat(@file).atime
		rescue
			aTime = Time.new(0)
		end
		return aTime
	end

	def calculate_file_exists
		doesFileExist = true
		begin
			File::Stat.new(@file)
		rescue
			doesFileExist = false
		end
		return doesFileExist
	end

	def file_created?
		oldExistsStatus = @exists
		@exists = self.calculate_file_exists

		if @exists and !oldExistsStatus
			return true
		end
		return false
	end

	def file_destroyed?
		oldExistsStatus = @exists
		@exists = self.calculate_file_exists

		if !@exists and oldExistsStatus
			return true
		end
		return false
	end

	def file_changed?
		oldTime = @time_altered
		@time_altered = self.calculate_last_altered_time

    	# No change
	    if oldTime == @time_altered
	    	return false
	    else
	    	return true
	    end
	end
end