require_relative 'file_command_parser'
require_relative '../precision/precision'

class FileWatcher
	def initialize(args)
		parser = FileCommandParser.new(args)

		@commandName = parser.command[0]
		# @commandClass = parser.command[1]
		# @commandClass.add_delay(delay)
		@args = parser.command[1]
		@delay = parser.delay

		if alteration == "-d"
			@alteration = "fileDestroyed?"
			alteration = "destroyed"
		elsif alteration == "-a"
			@alteration = "fileChanged?"
			alteration = "altered"
		else
			@alteration = "fileCreated?"
			alteration = "created"
		end

		@observers = self.createObserver(parser.files)
	end

	def createObserver(files)
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
					puts "The file '#{observer.file}' was #{alteration}... the command '#{@commandName}' will execute in #{@delay} milliseconds..."
					Precision::timer(@delay, Proc.new {exec(@commandName, @args)})
				end
			end
		end
	end

end


class Observer
	def initialize(file)
		@file = file
		@timeAltered = self.calculateLastAlteredTime
		@exists = self.calculateFileExists

	end

	def file
		return @file
	end

	def calculateLastAlteredTime
		begin
			aTime = File.stat(@file).atime
		rescue
			aTime = Time.new(0)
		end
		return aTime
	end

	def calculateFileExists
		doesFileExist = true
		begin
			File::Stat.new(@file)
		rescue
			doesFileExist = false
		end
		return doesFileExist
	end

	def fileCreated?
		oldExistsStatus = @exists
		@exists = self.calculateFileExists

		if @exists and !oldExistsStatus
			return true
		end
		return false
	end

	def fileDestroyed?
		oldExistsStatus = @exists
		@exists = self.calculateFileExists

		if !@exists and oldExistsStatus
			return true
		end
		return false
	end

	def fileChanged?
		oldTime = @timeAltered
		@timeAltered = self.calculateLastAlteredTime

    	# No change
	    if oldTime == @timeAltered
	    	return false
	    else
	    	return true
	    end
	end
end