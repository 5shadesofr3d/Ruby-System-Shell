require "test/unit"
require_relative 'command.rb'
require_relative 'shell_commands.rb'
class Shell
  include ShellCommands

  def initialize
    #Add command to hash map
    @commands = {'ls' => Proc.new {list_command}}
    main
  end

  def main
    #Main shell loop waiting for input
    input = ""
    while not input.eql? "exit"
      input = gets
      input.strip!
      #CHECK VALID HERE
      execute(input)
    end
  end

  def execute(cmd)
    #Get command from hash map
    # ASSERT VALID_CMD
    to_call = @commands[cmd]
    puts to_call
    begin
      to_call.call
    rescue
      #Note: This error should NOT be for when the command is invalid
      # It should only catch here when command execution encounters an error
      # invalid commands should be handled before we are here
      puts "Command failed to execute, please try again"
    end
  end
end

Shell.new