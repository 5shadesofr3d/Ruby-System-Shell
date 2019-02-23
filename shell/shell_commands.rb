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

  # NOTE: I have implemented the most important linux commands as mentioned by this guy:
  # https://www-uxsup.csx.cam.ac.uk/pub/doc/suse/suse9.0/userguide-9.0/ch24s04.html

  # I think this is what the idea ls should look like:
  # def self.ls(flags, args)
  #   assert if flags, flags is valid
  #   assert if args not empty, flags is valid
  #   exec("ls", flags, args)
  # end
  def self.ls(args)

    # Security contracts here... assuming call is(flags, args)
    # assert flags is valid
    # assert file exists?

    exec("ls", *args)
  end

  def self.cp(args)

    # Security contracts here...
    # assert flags is valid
    # assert file exists?

    exec("cp", *args)
  end

  def self.mv(args)

    # Security contracts here...
    # assert flags is valid
    # assert file exists?

    exec("mv", *args)
  end

  def self.rm(args)

    # Security contracts here...
    # assert flags is valid
    # assert file exists?

    exec("rm", *args)
  end

  def self.ln(args)

    # Security contracts here...
    # assert flags is valid
    # assert file exists?

    exec("ln", *args)
  end

  def self.mkdir(args)

    # Security contracts here...
    # assert flags is valid
    # assert directory name length

    exec("mkdir", *args)
  end

  def self.rmdir(args)

    # Security contracts here...
    # assert flags is valid
    # assert directory exists

    exec("rmdir", *args)
  end

  def self.chown(args)

    # Security contracts here...
    # assert flags is valid
    # assert file exists?

    exec("chown", *args)
  end

  def self.chgrp(args)

    # Security contracts here...
    # assert flags is valid
    # assert file exists?

    exec("chgrp", *args)
  end

  def self.chmod(args)

    # Security contracts here...
    # assert flags is valid
    # assert file exists?

    exec("chmod", *args)
  end

  def self.gzip(args)

    # Security contracts here...
    # assert flags is valid
    # assert file exists?

    exec("gzip", *args)
  end

  def self.tar(args)

    # Security contracts here...
    # assert flags is valid
    # assert file exists?

    exec("tar", *args)
  end

  def self.locate(args)

    # Security contracts here...
    # assert pattern is valid

    exec("locate", *args)
  end

  def self.updatedb(args)

    # Security contracts here...
    # assert flags is valid

    exec("updatedb", *args)
  end

  def self.myfind(args)

    # Security contracts here...
    # assert options is valid

    exec("find", *args)
  end

  def self.cat(args)

    # Security contracts here...
    # assert flags is valid
    # assert file exists?

    exec("cat", *args)
  end

  def self.myless(args)

    # Security contracts here...
    # assert flags is valid
    # assert file exists?

    exec("less", *args)
  end

  def self.grep(args)

    # Security contracts here...
    # assert flags is valid

    exec("grep", *args)
  end

  def self.diff(args)

    # Security contracts here...
    # assert flags is valid
    # assert file exists?

    exec("diff", *args)
  end

  def self.mount(args)

    # Security contracts here...

    exec("mount", *args)
  end

  def self.unmount(args)

    # Security contracts here...
    # assert flags is valid
    # assert directory exists?

    exec("unmount", *args)
  end

  def self.df(args)

    # Security contracts here...
    # assert flags is valid
    # assert directory exists?

    exec("df", *args)
  end

  def self.du(args)

    # Security contracts here...
    # assert flags is valid
    # assert path exists?

    exec("du", *args)
  end

  def self.free(args)

    # Security contracts here...
    # assert flags is valid

    exec("free", *args)
  end

  def self.date(args)

    # Security contracts here...
    # assert flags is valid

    exec("date", *args)
  end

  def self.top(args)

    # Security contracts here...
    # assert flags is valid

    exec("top", *args)
  end

  def self.ps(args)

    # Security contracts here...
    # assert flags is valid

    exec("ps", *args)
  end

  def self.kill(args)

    # Security contracts here...
    # assert flags is valid

    exec("kill", *args)
  end

  def self.killall(args)

    # Security contracts here...
    # assert flags is valid

    exec("killall", *args)
  end

  def self.ping(args)

    # Security contracts here...
    # assert flags is valid

    exec("ping", *args)
  end

  def self.nslookup(args)

    # Security contracts here...

    exec("nslookup", *args)
  end

  def self.telnet(args)

    # Security contracts here...
    # assert flags is valid

    exec("telnet", *args)
  end

  def self.passwd(args)

    # Security contracts here...
    # assert flags is valid

    exec("passwd", *args)
  end

  def self.su(args)

    # Security contracts here...
    # assert flags is valid

    exec("su", *args)
  end

  def self.halt(args)

    # Security contracts here...
    # assert flags is valid

    exec("halt", *args)
  end

  def self.reboot(args)

    # Security contracts here...
    # assert flags is valid
    #
    exec("reboot", *args)
  end

  def self.clear(args)

    # TODO: This should just clear the terminal.

    exec("clear", *args)
  end

end