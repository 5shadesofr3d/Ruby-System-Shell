require "test/unit"
require "colorize"
require "etc"
require_relative "command"
require_relative "shell_commands"

class Shell
	include Test::Unit::Assertions

	def initialize
		#Add command to hash map
		@active = false

		@commands = {
			'fw' => ForkCommand.new(nonblock = true) { |a| exec("ruby", "fw.rb", *a) },
			'dp' => ForkCommand.new(nonblock = true) { |a| exec("ruby", "dp.rb", *a) },
			'cd' => Command.new(nonblock = false) { |a| ShellCommands.cd(a) },
			'ls' => ForkCommand.new(nonblock = false) { |a| ShellCommands.ls(a) },
			'cp' => ForkCommand.new(nonblock = false) { |a| ShellCommands.cp(a) },
			'mv' => ForkCommand.new(nonblock = false) { |a| ShellCommands.mv(a) },
			'rm' => ForkCommand.new(nonblock = false) { |a| ShellCommands.rm(a) },
			'ln' => ForkCommand.new(nonblock = false) { |a| ShellCommands.ln(a) },
			'mkdir' => ForkCommand.new(nonblock = false) { |a| ShellCommands.mkdir(a) },
			'rmdir' => ForkCommand.new(nonblock = false) { |a| ShellCommands.rmdir(a) },
			'chown' => ForkCommand.new(nonblock = false) { |a| ShellCommands.chown(a) },
			'chgrp' => ForkCommand.new(nonblock = false) { |a| ShellCommands.chgrp(a) },
			'chmod' => ForkCommand.new(nonblock = false) { |a| ShellCommands.chmod(a) },
			'gzip' => ForkCommand.new(nonblock = false) { |a| ShellCommands.gzip(a) },
			'tar' => ForkCommand.new(nonblock = false) { |a| ShellCommands.tar(a) },
			'locate' => ForkCommand.new(nonblock = false) { |a| ShellCommands.locate(a) },
			'updatedb' => ForkCommand.new(nonblock = false) { |a| ShellCommands.updatedb(a) },
			'find' => ForkCommand.new(nonblock = false) { |a| ShellCommands.myfind(a) },
			'cat' => ForkCommand.new(nonblock = false) { |a| ShellCommands.cat(a) },
			'less' => ForkCommand.new(nonblock = false) { |a| ShellCommands.myless(a) },
			'grep' => ForkCommand.new(nonblock = false) { |a| ShellCommands.grep(a) },
			'diff' => ForkCommand.new(nonblock = false) { |a| ShellCommands.diff(a) },
			'mount' => ForkCommand.new(nonblock = false) { |a| ShellCommands.mount(a) },
			'unmount' => ForkCommand.new(nonblock = false) { |a| ShellCommands.unmount(a) },
			'df' => ForkCommand.new(nonblock = false) { |a| ShellCommands.df(a) },
			'du' => ForkCommand.new(nonblock = false) { |a| ShellCommands.du(a) },
			'free' => ForkCommand.new(nonblock = false) { |a| ShellCommands.free(a) },
			'date' => ForkCommand.new(nonblock = false) { |a| ShellCommands.date(a) },
			'top' => ForkCommand.new(nonblock = false) { |a| ShellCommands.top(a) },
			'ps' => ForkCommand.new(nonblock = false) { |a| ShellCommands.ps(a) },
			'kill' => ForkCommand.new(nonblock = false) { |a| ShellCommands.kill(a) },
			'killall' => ForkCommand.new(nonblock = false) { |a| ShellCommands.killall(a) },
			'ping' => ForkCommand.new(nonblock = false) { |a| ShellCommands.ping(a) },
			'nslookup' => ForkCommand.new(nonblock = false) { |a| ShellCommands.nslookup(a) },
			'telnet' => ForkCommand.new(nonblock = false) { |a| ShellCommands.telnet(a) },
			'passwd' => ForkCommand.new(nonblock = false) { |a| ShellCommands.passwd(a) },
			'su' => ForkCommand.new(nonblock = false) { |a| ShellCommands.su(a) },
			'halt' => ForkCommand.new(nonblock = false) { |a| ShellCommands.halt(a) },
			'reboot' => ForkCommand.new(nonblock = false) { |a| ShellCommands.reboot(a) },
			'clear' => ForkCommand.new(nonblock = false) { |a| ShellCommands.clear(a) },
			'exit' => Command.new { self.exit }
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
		assert valid?

		while @active
			print "#{Etc.getlogin}@".light_green.bold + "#{Dir.pwd}".light_blue.bold + "$ "
			input = gets
			input = input.split

			if input.empty?
				next
			end

			# TODO: using parser, break input into: command args
			command = input[0]
			args = input.drop(1)

			#CHECK VALID HERE

			self.execute(command, args)
		end

		assert valid?
	end

	def execute(cmd, *args)
		#Get command from hash map
		# ASSERT VALID_CMD
		to_call = nil

		if @commands.key? cmd
			to_call = @commands[cmd]
		else
			to_call = ForkCommand.new do |a|
				if a.empty?
					exec(cmd)
				else
					exec(cmd, *a)
				end
			end
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