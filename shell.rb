require "test/unit"
require_relative 'command.rb'
require_relative 'shell_commands.rb'
require_relative 'file_watch.rb'

class Shell
  include ShellCommands
  include Test::Unit::Assertions

  def initialize
    #Add command to hash map
    @active = false

    def fileWatch (arg)
      print "Hello World "
      for a in arg
        print a + " "
      end
      print "\n"
    end

    @commands = {
      'ls' => ForkCommand.new { exec "ls" },
      'exit' => Command.new { self.exit },
      'filewatch' => ForkCommand.new {|args| FileWatcher.new(args)}
    }

    assert valid?
  end

  def valid?
    # TODO: class invariants
    return true
  end

  def start
    # starts the shell
    assert valid?

    @active = true
    self.main
  end

  def exit
    assert valid?

    @active = false

    assert valid?
  end

  def main
    #Main shell loop waiting for input
    while @active
      print ">>> "
      input = gets
      input = input.split

      # TODO: using parser, break input into: command args
      command = input[0]
      args = input.drop(1)

      #CHECK VALID HERE

      self.execute(command, args)
    end
  end

  def execute(cmd, *args)
    #Get command from hash map
    # ASSERT VALID_CMD
    to_call = nil

    if @commands.key? cmd
      to_call = @commands[cmd]
    else
      to_call = ForkCommand.new { exec(cmd) }
    end

    assert to_call.is_a? Command

    begin
      id = to_call.execute(*args)
      to_call.wait(id) unless to_call.nonblocking?
    rescue
      #Note: This error should NOT be for when the command is invalid
      # It should only catch here when command execution encounters an error
      # invalid commands should be handled before we are here
      puts "Command failed to execute, please try again"
    end
  end
end

shell = Shell.new
shell.start
