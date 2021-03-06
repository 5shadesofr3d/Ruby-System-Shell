require "test/unit"
require "colorize"
require "etc"
require_relative "command"
require_relative "shell_commands"
require_relative "monitor"

class Shell
	include Test::Unit::Assertions

	ENV["MAX_NUM_PROCESS"] = 10.to_s

	def initialize
		#Add command to hash map
		@active = false
		@initial_dir = Dir.pwd
		@monitor = Monitor.new(Process.pid)

		@commands = {
			'fw' => ForkCommand.new(nonblock = true) { |a| exec("ruby", "#{@initial_dir}/fw.rb", *a) },
			'dp' => ForkCommand.new(nonblock = true) { |a| exec("ruby", "#{@initial_dir}/dp.rb", *a) },
			'cd' => Command.new { |a| ShellCommands.cd(*a) },
			'envar' => Command.new { |a| ShellCommands.envar(*a) },
			'monitor' => Command.new { @monitor.print_processes },
			'exit' => Command.new { self.exit }
		}

		#post
		assert !@active
		assert @initial_dir.is_a? String
		assert @commands.is_a? Hash
		@commands.each_key { |a| assert a.is_a? String  }
		@commands.each_value {|v| assert v.is_a? Command }
		assert valid?
	end

	def valid?
		return false unless @commands.is_a? Hash
		return false unless @initial_dir.is_a? String
		return false unless (@active == false || @active == true)
		return false unless @commands.size > 0 #This should never be 0
		return false unless !@initial_dir.empty? #working directory should never be ""
		@commands.each_key {|key| return false unless key.is_a? String}
		@commands.each_value {|val| return false unless val.is_a? Command}
		return true
	end

	def valid_command?(cmd)
		#pre
		assert valid?
		assert cmd.is_a? String

		if (@commands.key? cmd)
			return true
		else
			return which(cmd)
		end

		#post
		assert cmd.is_a? String
		assert valid?
	end

	def which(cmd)
		#pre
		assert valid?
		assert cmd.is_a? String

		# Credit to: https://stackoverflow.com/questions/2108727/which-in-ruby-checking-if-program-exists-in-path-from-ruby
		begin
			exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
			ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
				exts.each { |ext|
					exe = File.join(path, "#{cmd}#{ext}")
					return true if File.executable?(exe) && !File.directory?(exe)
				}
			end
		rescue ArgumentError => e
			puts e.message.red.bold
			return false
		end

		#post
		assert exts.is_a? Array
		assert exts.each {|e| assert e.is_a? String}
		assert valid?

		return false
	end

	def MAX_NUM_PROCESS
		return ENV["MAX_NUM_PROCESS"].to_i
	end

	def start
		# starts the shell
		# pre
		assert valid?
		assert !@active

		@active = true
		@monitor_thread = Thread.new do
			@monitor.run
		end

		self.main

		#post
		assert !@active #upon exit of main loop, we are unactive again
		assert valid?
	end

	def exit
		#pre
		assert valid?
		assert @active

		assert (@active == true), "Cannot exit if the shell was never started"

		@active = false

		@monitor.active = false
		@monitor_thread.join
		puts "Cleaning up the following jobs:".yellow.bold
		@monitor.print_processes
		@monitor.cleanup

		#post
		assert !@active
		assert @monitor.num_processes == 0 # this process is the only one running

		assert valid?
	end

	def prompt
		return "#{Etc.getlogin}@".light_green.bold + "#{Dir.pwd}".light_blue.bold + "$ "
	end

	# The main loop without the loop.
	# Let's us inject input for fuzzy testing.
	def test_main(input)
		assert valid?

		# print prompt -> Don't care about prompt.
		assert input.is_a? String
		input = input.split

		if not input.empty?
			command = input[0]
			args = input.drop(1)

			if valid_command?(command)
				self.execute(command, args)
			else
				puts "Error: The entered command '#{command}' is not a valid Unix command".red.bold
			end
		end

		assert valid?
	end


	def main
		#Main shell loop waiting for input
		# pre
		assert valid?
		assert @active

		while @active
			poll_user
		end

		#post
		assert !@active
		assert valid?
	end

	def poll_user
		#pre
		assert valid?
		assert @active

		print prompt
		input = gets
		assert input.is_a? String
		input = input.split

		if input.empty?
			return
		end

		# TODO: using parser, break input into: command args
		command = input[0]
		args = input.drop(1)

		#CHECK VALID HERE
		if valid_command?(command)
			self.execute(command, args)
		else
			puts "Error: The entered command '#{command}' is not a valid Unix command".red.bold
		end

		#post
		assert input.is_a? Array
		assert command.is_a? String
		assert args.is_a? Array
		assert valid?
	end

	def execute(cmd, *args)
		#pre
		assert valid?
		assert cmd.is_a? String
		assert args.is_a? Array
		assert args.each {|a| a.is_a? String}

		to_call = nil

		if @commands.key? cmd
			to_call = @commands[cmd]
		else
			to_call = ForkCommand.new { |a| exec(*[cmd, *a]) }
		end

		begin
			if (to_call.is_a? ForkCommand) and (self.MAX_NUM_PROCESS <= @monitor.num_processes)
				raise Exception, "Cannot run anymore processes without exceeding max processes count of #{self.MAX_NUM_PROCESS}"
			end

			id = to_call.execute(*args)
			to_call.wait(id) unless to_call.nonblocking?
		rescue Exception => e
			#Note: This error should NOT be for when the command is invalid
			# It should only catch here when command execution encounters an error
			# invalid commands should be handled before we are here
			puts e.message.red.bold
		end

		#post
		assert to_call.is_a? Command
		assert valid?
	end
end
