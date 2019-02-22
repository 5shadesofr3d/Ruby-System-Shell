class FileWatch
	def initialize(alteration, files, command, delay)
		@files = files

		@commandName = command[0]
		@commandClass = command[1]
		@commandClass.add_delay(delay)
		@args = command[2]

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

		@watchList = self.createWatchList


		while true
			for watcher in @watchList
				if watcher.send(@alteration)
					print "\nThe file '#{watcher.file}' was #{alteration}... the command '#{@commandName}' will execute in #{delay} seconds...\n\n"
					@commandClass.execute(@args)
				end
			end
		end
	end

	def createWatchList
		watchList = []
		for file in @files
			watchList += [Watcher.new(file)]
		end
		return watchList
	end

end


class Watcher
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