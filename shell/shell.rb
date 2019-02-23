require "test/unit"
require "colorize"
require "etc"
require 'mkmf'
require_relative "command"

class Shell
	include Test::Unit::Assertions

	def initialize
		#Add command to hash map
		@active = false

		@commands = {
			'fw' => ForkCommand.new(nonblock = true) { |a| exec("ruby", "fw.rb", *a) },
			'dp' => ForkCommand.new(nonblock = true) { |a| exec("ruby", "dp.rb", *a) },
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
					exec(cmd, a.join(" "))
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