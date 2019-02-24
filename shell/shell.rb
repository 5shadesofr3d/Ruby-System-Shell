require "test/unit"
require "colorize"
require "etc"
require_relative "command"
require_relative "shell_commands"

class Shell
	include Test::Unit::Assertions
	include ShellCommands

	def initialize
		#Add command to hash map
		@active = false
		@initial_dir = Dir.pwd

		@commands = {
			'fw' => ForkCommand.new(nonblock = true) { |a| exec("ruby", "#{@initial_dir}/fw.rb", *a) },
			'dp' => ForkCommand.new(nonblock = true) { |a| exec("ruby", "#{@initial_dir}/dp.rb", *a) },
			'cd' => Command.new(nonblock = false) { |a| ShellCommands.cd(a) },
			'exit' => Command.new { self.exit }
		}

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
		assert valid?
		assert cmd.is_a? String

		if (@commands.key? cmd)
			return true
		else
			return which(cmd)
		end
	end

	def which(cmd)
		assert valid?
		assert cmd.is_a? String
		# Stolen from: https://stackoverflow.com/questions/2108727/which-in-ruby-checking-if-program-exists-in-path-from-ruby
		exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
		ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
			exts.each { |ext|
				exe = File.join(path, "#{cmd}#{ext}")
				return true if File.executable?(exe) && !File.directory?(exe)
			}
		end
		return false
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

	def prompt
		return "#{Etc.getlogin}@".light_green.bold + "#{Dir.pwd}".light_blue.bold + "$ "
	end

	def main
		#Main shell loop waiting for input
		assert valid?

		while @active
			assert valid?
			print prompt
			input = gets
			assert input.is_a? String
			input = input.split

			if input.empty?
				next
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
			assert valid?
		end

		assert valid?
	end

	def execute(cmd, *args)

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

			assert id
			to_call.wait(id) unless to_call.nonblocking?
		rescue
			#Note: This error should NOT be for when the command is invalid
			# It should only catch here when command execution encounters an error
			# invalid commands should be handled before we are here
			puts "Error: The command failed to execute, please try again".red.bold
		end
	end
end
