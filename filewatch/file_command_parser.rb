
class FileCommandParser

	attr_reader :monitorType, :files, :command, :delay

	def initialize(args)
		@args = args
		@delay = 0
		@command = []
		@files = []
		@monitorType = nil
		@FileWatcher = nil
		self.checkForErrors
	end

	def checkForErrors
		optionsGiven = @args.select { |element| element[0] == '-'} #list of options given
		optionsIndex = @args.each_index.select { |i|  @args[i][0] == '-'} #list of indexes for said options

		# If invalid options are given...
		optionsGiven.each do |element|
			unless (element.length == 2 and ["f", "t", "d", "a", "c"].include? element[1])
				raise ArgumentError, "Invalid option defined for filewatch (#{element} was given)... in general only -f, -t, and one of -d, -a, or -c are allowed"
			end
		end

		# Duplicate options are given...
		unless (optionsGiven.length == optionsGiven.uniq.length)
			raise ArgumentError, "Duplicate option was given, only one of -f, one of -t, and one of -d, -a, or -c are allowed"
		end

		# -f exists...
		unless (optionsGiven.include? "-f")
			raise ArgumentError, "Files to monitor must be specified with the option -f, followed by <file1 file2... fileN>"
		end

		# -d or -a or -c exists...
		unless (optionsGiven.include? "-d" or optionsGiven.include? "-a" or optionsGiven.include? "-c")
			raise ArgumentError, "File monitoring option must be specified with either -d, -a, or -c, followed by <command <arg1 arg2... argN>?"
		end

		# Only one of -d, -a, or -c exists...
		unless ((optionsGiven.include? "-d" and !optionsGiven.include? "-a" and !optionsGiven.include? "-c") \
			or (optionsGiven.include? "-a" and !optionsGiven.include? "-d" and !optionsGiven.include? "-c") \
			or (optionsGiven.include? "-c" and !optionsGiven.include? "-a" and !optionsGiven.include? "-d"))
			
			raise ArgumentError, "Only one of the file monitoring options (-d, -a, or -c) may be specified"
		end

		#Error checking done, time to push arguments to their individual functions....
		for index in 0..optionsGiven.length - 1
			# If the last option...
			if index + 1 == optionsGiven.length
				evalOption(optionsGiven[index], optionsIndex[index] + 1, @argsLength - 1)
			else
				evalOption(optionsGiven[index], optionsIndex[index] + 1, optionsIndex[index + 1] - 1)
			end
		end
	end

	def evalOption(monitorType, indexStart, indexFinish)
		if monitorType == "-f"
			evalFiles(indexStart, indexFinish)
		elsif monitorType == "-t"
			evalDelay(indexStart, indexFinish)
		else
			evalMonitorType(monitorType, indexStart, indexFinish)
		end
	end

	def evalFiles(indexStart, indexFinish)
		unless indexFinish > indexStart - 1
			raise ArgumentError, "Files to monitor should be passed after the -f option, when 0 arguments were given"
		end

		for i in indexStart... indexFinish + 1
			@files += [@args[i]]
		end
	end

	def evalDelay(indexStart, indexFinish)
		# If multiple args given
		unless indexFinish == indexStart
			raise ArgumentError, "Only one argument should be passed after the -t option, when #{indexFinish - indexStart + 1} arguments were given"
		end

		arg = @args[indexStart]

		# If args given is not a number, or is a number not between 0 and 600...
		unless ((arg.is_a? Numeric) and (0 <= arg))
			raise ArgumentError, "Argument given after -t (#{arg}) must a positive number between 0 and 600"
		end

		@delay = arg.to_f
	end


	def evalMonitorType(monitorType, indexStart, indexFinish)
		@monitorType = monitorType
		# If no args given...
		unless (indexFinish > indexStart - 1)
			raise ArgumentError, "Command to execute should be passed after the #{@monitorType} option, when 0 arguments were given"
		end

		@command += [@args[indexStart]]

		for i in indexStart + 1... indexFinish + 1
			@command[1] += @args[i] + " "
		end
	end

end

# #print ">>> "
# input = "filewatch -f a.rb -t 6 -d ls"
# input = input.split
#
# # TODO: using parser, break input into: command args
# command = input[0]
# args = input.drop(1)
#
# commands = {
#     'ls' => ForkCommand.new { exec "ls" },
#     'exit' => Command.new { self.exit },
#     'filewatch' => ForkCommand.new {|args| FileCommandParser.new(args, commands)}
#
# }
#
#
# f = FileCommandParser.new(args, commands)

