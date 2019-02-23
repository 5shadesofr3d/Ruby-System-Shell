require_relative '../precision/precision'

#Commands here will instantiate a command object then pass a block to it
module ShellCommands

  # TODO: In some cases, the file directory string printed does not change. I think
  # this is a race condition between this function and the printing function.
  def cd
    return Command.new(nonblocking = false) do |filepath|
      begin
        assert filepath.length > 0, "A filepath was not entered"
        
        Dir.chdir(filepath[0]) # Slight bug, it breaks slightly when
      rescue SystemCallError
        puts "Target directory does not exist."
      rescue Test::Unit::AssertionFailedError => e
        puts e.message
      end
    end
  end

  # NOTE: I have implemented the most important linux commands as mentioned by this guy:
  # https://www-uxsup.csx.cam.ac.uk/pub/doc/suse/suse9.0/userguide-9.0/ch24s04.html

  # I think this is what the idea ls should look like:
  # def self.ls(flags, args)
  #   assert if flags, flags is valid
  #   assert if args not empty, flags is valid
  #   exec("ls", flags, args)
  # end
  def ls
    return ForkCommand.new(nonblocking = false) do |args|
      # Security contracts here... assuming call is(flags, args)
      # assert flags is valid
      # assert file exists?
      exec("ls", *args)
    end
  end

  def cp
    return ForkCommand.new(nonblocking = false) do |args|
      # Security contracts here...
      # assert flags is valid
      # assert file exists?

      exec("cp", *args)
    end
  end

  def mv
    return ForkCommand.new(nonblocking = false) do |args|
      # Security contracts here...
      # assert flags is valid
      # assert file exists?

      exec("mv", *args)
    end
  end

  def rm
    return ForkCommand.new(nonblocking = false) do |args|
      # Security contracts here...
      # assert flags is valid
      # assert file exists?

      exec("rm", *args)
    end
  end

  def ln
    return ForkCommand.new(nonblocking = false) do |args|
      # Security contracts here...
      # assert flags is valid
      # assert file exists?

      exec("ln", *args)
    end
  end

  def mkdir
    return ForkCommand.new(nonblocking = false) do |args|
      # Security contracts here...
      # assert flags is valid
      # assert file exists?

      exec("mkdir", *args)
    end
  end

  def rmdir
    return ForkCommand.new(nonblocking = false) do |args|
      # Security contracts here...
      # assert flags is valid
      # assert file exists?

      exec("rmdir", *args)
    end
  end

  def chown
    return ForkCommand.new(nonblocking = false) do |args|
      # Security contracts here...
      # assert flags is valid
      # assert file exists?

      exec("chown", *args)
    end
  end

  def chgrp
    return ForkCommand.new(nonblocking = false) do |args|
      # Security contracts here...
      # assert flags is valid
      # assert file exists?

      exec("chgrp", *args)
    end
  end

  def chmod
    return ForkCommand.new(nonblocking = false) do |args|
      # Security contracts here...
      # assert flags is valid
      # assert file exists?

      exec("chmod", *args)
    end
  end

  def gzip
    return ForkCommand.new(nonblocking = false) do |args|
      # Security contracts here...
      # assert flags is valid
      # assert file exists?

      exec("gzip", *args)
    end
  end

  def tar
    return ForkCommand.new(nonblocking = false) do |args|
      # Security contracts here...
      # assert flags is valid
      # assert file exists?

      exec("tar", *args)
    end
  end

  def locate
    return ForkCommand.new(nonblocking = false) do |args|
      # Security contracts here...
      # assert pattern is valid

      exec("locate", *args)
    end
  end

  def updatedb
    return ForkCommand.new(nonblocking = false) do |args|
      # Security contracts here...
      # assert flags is valid

      exec("updatedb", *args)
    end
  end

  def myfind
    return ForkCommand.new(nonblocking = false) do |args|
      # Security contracts here...
      # assert options is valid

      exec("find", *args)
    end
  end

  def cat
    return ForkCommand.new(nonblocking = false) do |args|
      # Security contracts here...
      # assert flags is valid
      # assert file exists?

      exec("cat", *args)
    end
  end

  def myless
    return ForkCommand.new(nonblocking = false) do |args|
      # Security contracts here...
      # assert flags is valid
      # assert file exists?

      exec("less", *args)
    end
  end

  def grep
    return ForkCommand.new(nonblocking = false) do |args|
      # Security contracts here...
      # assert flags is valid

      exec("grep", *args)
    end
  end

  def diff
    return ForkCommand.new(nonblocking = false) do |args|
      # Security contracts here...
      # assert flags is valid
      # assert file exists?

      exec("diff", *args)
    end
  end

  def mount
    return ForkCommand.new(nonblocking = false) do |args|
      # Security contracts here...

      exec("mount", *args)
    end
  end

  def unmount
    return ForkCommand.new(nonblocking = false) do |args|
      # Security contracts here...
      # assert flags is valid
      # assert directory exists?

      exec("unmount", *args)
    end
  end

  def df
    return ForkCommand.new(nonblocking = false) do |args|
      # Security contracts here...
      # assert flags is valid
      # assert directory exists?

      exec("df", *args)
    end
  end

  def du
    return ForkCommand.new(nonblocking = false) do |args|
      # Security contracts here...
      # assert flags is valid
      # assert path exists?

      exec("du", *args)
    end
  end

  def free
    return ForkCommand.new(nonblocking = false) do |args|
      # Security contracts here...
      # assert flags is valid

      exec("free", *args)
    end
  end

  def date
    return ForkCommand.new(nonblocking = false) do |args|
      # Security contracts here...
      # assert flags is valid

      exec("date", *args)
    end
  end

  def top
    return ForkCommand.new(nonblocking = false) do |args|
      # Security contracts here...
      # assert flags is valid

      exec("top", *args)
    end
  end

  def ps
    return ForkCommand.new(nonblocking = false) do |args|
      # Security contracts here...
      # assert flags is valid

      exec("ps", *args)
    end
  end

  def kill
    return ForkCommand.new(nonblocking = false) do |args|
      # Security contracts here...
      # assert flags is valid

      exec("kill", *args)
    end
  end

  def killall
    return ForkCommand.new(nonblocking = false) do |args|
      # Security contracts here...
      # assert flags is valid

      exec("killall", *args)
    end
  end

  def ping
    return ForkCommand.new(nonblocking = false) do |args|
      # Security contracts here...
      # assert flags is valid

      exec("ping", *args)
    end
  end

  def nslookup
    return ForkCommand.new(nonblocking = false) do |args|
      # Security contracts here...

      exec("nslookup", *args)
    end
  end

  def telnet
    return ForkCommand.new(nonblocking = false) do |args|
      # Security contracts here...
      # assert flags is valid

      exec("telnet", *args)
    end
  end

  def passwd
    return ForkCommand.new(nonblocking = false) do |args|
      # Security contracts here...
      # assert flags is valid

      exec("passwd", *args)
    end
  end

  def su
    return ForkCommand.new(nonblocking = false) do |args|
      # Security contracts here...
      # assert flags is valid

      exec("su", *args)
    end
  end

  def halt
    return ForkCommand.new(nonblocking = false) do |args|
      # Security contracts here...
      # assert flags is valid

      exec("halt", *args)
    end
  end

  def reboot
    return ForkCommand.new(nonblocking = false) do |args|
      # Security contracts here...
      # assert flags is valid
      #
      exec("reboot", *args)
    end
  end

  def clear
    return ForkCommand.new(nonblocking = false) do |args|
      # TODO: This should just clear the terminal.

      exec("clear", *args)
    end
  end

  def fw
    return ForkCommand.new(nonblocking = true) do |args|
      begin
        file_watcher = FileWatcher.new(args)
        file_watcher.watch
      rescue Exception => e
        puts e.message
      end
    end
  end

  def dp
    return ForkCommand.new(nonblocking = true) do |args|
      begin
        assert (args.length >= 2), "Expected atleast 2 arguments, but got: #{args.length}"

        time, *message = *args
        time = time.to_i

        assert (time.is_a? Integer), "Expected time parameter to be an integer, but got: #{time.class}"
        assert (time >= 0), "Expected time value >= 0, but got: #{time}"

        Precision::timer_ms(time, Proc.new { puts message.join(" ") })
      rescue Exception => e
        puts e.message
      end
    end
  end

end