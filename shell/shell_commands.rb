require "test/unit"

#Commands here will instantiate a command object then pass a block to it
module ShellCommands
  include Test::Unit::Assertions

  # TODO: In some cases, the file directory string printed does not change. I think
  # this is a race condition between this function and the printing function.
  def self.cd(filepath)

    # assert filepath[0].length > 0 -> Assertions aren't working, not sure why.

    begin
      Dir.chdir(filepath[0]) # Slight bug, it breaks slightly when
    rescue SystemCallError
      puts "Target directory does not exist."
    end

  end

end