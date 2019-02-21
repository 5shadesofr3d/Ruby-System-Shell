

class FileWatcher

  def initialize(args)
		@args = args
    @argsLength = @args.length
    @delay = 0
    @command = nil
    @files = nil
    self.checkForErrors

    print @delay
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
        evalOption(optionsGiven[index], optionsIndex[index], @argsLength)
      else
        evalOption(optionsGiven[index], optionsIndex[index], optionsIndex[index + 1])
      end
    end
  end

  def evalOption(optionType, indexStart, indexFinish)
    if optionType == "-f"
      evalFiles(indexStart, indexFinish)
    elsif optionType == "-t"
      evalDelay(indexStart, indexFinish)
    else
      evalMonitorType(indexStart, indexFinish)
    end
  end

  def evalFiles(indexStart, indexFinish)
    for i in indexStart... indexFinish
      print @args[i] + " "
    end
    print "\n"
  end

  def evalDelay(indexStart, indexFinish)
    # If multiple args given
    raise ArgumentError, "Only one argument should be passed after the -t option, when #{indexFinish - indexStart - 1} arguments were given" unless indexFinish - indexStart == 2

    arg = @args[indexStart + 1]

    # If args given is not a number, or is a number not between 0 and 600...
    raise ArgumentError, "Argument given after -t (#{arg}) must a positive number between 0 and 600" unless (arg.to_f.to_s == arg or arg.to_i.to_s == arg) and 0 <= arg.to_f and arg.to_f <= 600

    @delay = arg.to_f
  end



  def evalMonitorType(indexStart, indexFinish)
    for i in indexStart... indexFinish
      print @args[i] + " "
    end
    print "\n"
  end

end

#print ">>> "
input = "filewatch -f fwefijo fef -d yes"
input = input.split

# TODO: using parser, break input into: command args
command = input[0]
args = input.drop(1)
f = FileWatcher.new(args)
