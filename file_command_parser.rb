require_relative 'file_watcher.rb'
require_relative 'command.rb'

class FileCommandParser

	def initialize(args, commands)
		@args = args
		@argsLength = @args.length
		@delay = 0
		@command = []
		@files = []
		@monitorType = nil
		@FileWatcher = nil
		@commandLibrary = self.filterCommands(commands)
		self.checkForErrors
		@FileWatcher = FileWatch.new(@monitorType, @files, @command, @delay)
	end

	def checkForErrors
		optionsGiven = @args.select { |element| element[0] == '-'} #list of options given
		optionsIndex = @args.each_index.select { |i|  @args[i][0] == '-'} #list of indexes for said options

		# If invalid options are given...
		optionsGiven.each do |element|
			raise ArgumentError, "Invalid option defined for filewatch (#{element} was given)... in general only -f, -t, and one of -d, -a, or -c are allowed" unless element.length == 2 and (element[1] == "f" or element[1] == "t" or element[1] == "d" or element[1] == "a" or element[1] == "c")
		end

		# Duplicate options are given...
		raise ArgumentError, "Duplicate option was given, only one of -f, one of -t, and one of -d, -a, or -c are allowed" unless optionsGiven.length == optionsGiven.uniq.length

		# -f exists...
		raise ArgumentError, "Files to monitor must be specified with the option -f, followed by <file1 file2... fileN>" unless optionsGiven.include? "-f"

		# -d or -a or -c exists...
		raise ArgumentError, "File monitoring option must be specified with either -d, -a, or -c, followed by <command <arg1 arg2... argN>?" unless optionsGiven.include? "-d" or optionsGiven.include? "-a" or optionsGiven.include? "-c"

		# Only one of -d, -a, or -c exists...
		raise ArgumentError, "Only one of the file monitoring options (-d, -a, or -c) may be specified" unless (optionsGiven.include? "-d" and !optionsGiven.include? "-a" and !optionsGiven.include? "-c") or (optionsGiven.include? "-a" and !optionsGiven.include? "-d" and !optionsGiven.include? "-c") or (optionsGiven.include? "-c" and !optionsGiven.include? "-a" and !optionsGiven.include? "-d")

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
		raise ArgumentError, "Files to monitor should be passed after the -f option, when 0 arguments were given" unless indexFinish > indexStart - 1
		for i in indexStart... indexFinish + 1
			@files += [@args[i]]
		end
	end

	def evalDelay(indexStart, indexFinish)
		# If multiple args given
		raise ArgumentError, "Only one argument should be passed after the -t option, when #{indexFinish - indexStart + 1} arguments were given" unless indexFinish == indexStart

		arg = @args[indexStart]

		# If args given is not a number, or is a number not between 0 and 600...
		raise ArgumentError, "Argument given after -t (#{arg}) must a positive number between 0 and 600" unless (arg.to_f.to_s == arg or arg.to_i.to_s == arg) and 0 <= arg.to_f and arg.to_f <= 600

		@delay = arg.to_f
	end


	def evalMonitorType(monitorType, indexStart, indexFinish)
		@monitorType = monitorType
		# If no args given...
		raise ArgumentError, "Command to execute should be passed after the #{@monitorType} option, when 0 arguments were given" unless indexFinish > indexStart - 1
		# If invalid command is given...
		raise ArgumentError, "The command given (#{@args[indexStart]}) is not part of the user defined library" unless @commandLibrary.key?(@args[indexStart]) and @commandLibrary[@args[indexStart]].class == ForkCommand and @args[indexStart] != 'filewatch'
		@command += [@args[indexStart]]
		@command += [@commandLibrary[@command[0]]]
		@command[2] = ""
		for i in indexStart + 1... indexFinish + 1
			@command[1] += @args[i] + " "
		end
	end

	def filterCommands(commands)
		# Go through each command in the hash map, if it is a normal command (not forked) then get rid of it
		commands = commands.reject { |k,v| v.class != ForkCommand or k == 'filewatch'}

		# commands.each do |k, v|
		#   v.add_delay(@delay)
		# end

		return commands
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

