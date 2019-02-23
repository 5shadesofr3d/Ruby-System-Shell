require 'test/unit'
class FileCommandParser
	include Test::Unit::Assertions
	attr_reader :monitor_type, :files, :command, :delay

	def initialize(args)
		assert args.is_a? Array
		args.each { |a| assert a.is_a? String }
		@args = args
		@delay = 0
		@command = []
		@files = []
		@monitor_type = nil
		self.check_for_errors
		assert valid?
	end

	def valid?
		return false unless @args.is_a? Array
		@args.each { |a| return false unless a.is_a? String }
		return false unless @files.is_a? Array
		@files.each {|f| return false unless f.is_a? String}
		return false unless @command.is_a? Array
		@command.each {|c| return false unless c.is_a? String}
		return false unless @monitor_type.is_a? String
		return false unless @delay.is_a? Numeric
		return false unless @delay >= 0 #delay cant be neg
		return true
	end

	def check_for_errors
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
				eval_option(optionsGiven[index], optionsIndex[index] + 1, @args.length - 1)
			else
				eval_option(optionsGiven[index], optionsIndex[index] + 1, optionsIndex[index + 1] - 1)
			end
		end
		#post
		assert valid?
	end

	def eval_option(monitor_type, indexStart, indexFinish)
		assert monitor_type.is_a? String
		assert indexStart.is_a? Numeric
		assert indexFinish.is_a? Numeric
		if monitor_type == "-f"
			eval_files(indexStart, indexFinish)
		elsif monitor_type == "-t"
			eval_delay(indexStart, indexFinish)
		else
			eval_monitor_type(monitor_type, indexStart, indexFinish)
		end
	end

	def eval_files(indexStart, indexFinish)
		assert indexStart.is_a? Numeric
		assert indexFinish.is_a? Numeric
		unless indexFinish > indexStart - 1
			raise ArgumentError, "Files to monitor should be passed after the -f option, when 0 arguments were given"
		end

		for i in indexStart... indexFinish + 1
			@files += [@args[i]]
		end
	end

	def eval_delay(indexStart, indexFinish)
		assert indexStart.is_a? Numeric
		assert indexFinish.is_a? Numeric
		# If multiple args given
		unless indexFinish == indexStart
			raise ArgumentError, "Only one argument should be passed after the -t option, when #{indexFinish - indexStart + 1} arguments were given"
		end

		arg = @args[indexStart]

		@delay = arg.to_f
		# If args given is not a number, or is a number not between 0 and 600...
		unless ((@delay.is_a? Numeric) and (0 <= @delay))
			raise ArgumentError, "Argument given after -t (#{arg}) must a positive number between 0 and 600"
		end

		#post
		assert @delay.is_a? Numeric
		assert @delay >= 0
	end


	def eval_monitor_type(monitor_type, indexStart, indexFinish)
		assert monitor_type.is_a? String
		assert indexStart.is_a? Numeric
		assert indexFinish.is_a? Numeric
		@monitor_type = monitor_type
		# If no args given...
		unless (indexFinish > indexStart - 1)
			raise ArgumentError, "Command to execute should be passed after the #{@monitor_type} option, when 0 arguments were given"
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

