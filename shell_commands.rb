#Commands here will instantiate a command object then pass a block to it
module ShellCommands
  def list_command
    cmd = Command.new
    cmd.execute { puts 'my first shell command' }
  end
end