

class FileWatcher

  def initialize(args)
		@args = args
    @delay = nil
    @command = nil
    @files = nil
    self.checkForErrors
	end

  def checkForErrors
    # Initialize locations of argument...
    index = 0
    argsFound = 0
    arrayLength = @args.length

    while (argsFound < 3 and index < arrayLength)
      option = @args[index]

      # Specifying the time option...
      if option == "-t"
        index = evalDelay(index)
      elsif option == "-d" or option == "-a" or option == "-c"
        index = evalOption(index)
      elsif option == "-f"
        index = evalFiles(index)
      else
        raise ArgumentError, "Argument #{option} is not valid... please try again"
      end
    end

    raise ArgumentError, "Files to monitor must be specified, with -f <file1 file2... fileN>" unless !@files.nil?
    raise ArgumentError, "Option must be specified, with -c <option <arg1 arg2... argN>> for file creation, -d <option <arg1 arg2... argN>> for file destruction, or -a <option <arg1 arg2... argN>> for file alteration" unless !@command.nil?

  end

  def evalDelay(index)
    print @args[index] + "\n"
    return index + 2
  end

  def evalOption(index)
    print @args[index] + "\n"
  end

  def evalFiles(index)
    print @args[index] + "\n"
  end

end

#print ">>> "
input = "filewatch -t"
input = input.split

# TODO: using parser, break input into: command args
command = input[0]
args = input.drop(1)
f = FileWatcher.new(args)
