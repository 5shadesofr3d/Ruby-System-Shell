require 'test/unit'
#require_relative 'fileWatcher'

class Command
	include Test::Unit::Assertions

	attr_reader :block, :nonblock

	def initialize(nonblock = false, &block)
		@nonblock = nonblock
		@block = block

		assert valid?
	end

	def valid?
		return false unless (nonblock == true || nonblock == false)
		return false unless @block.is_a? Proc

		return true
	end

	def execute(*args)
		# block passed in is the command itself?
		assert valid?

		thread = Thread.new do
			@block.call(*args)
		end

		assert valid?

		return thread
	end

	def wait(thread)
		# waits until thread has finished calling
		thread.join
	end

	def nonblocking?
		assert valid?

		return @nonblock
	end
end

class ForkCommand < Command
	def execute(*args)
		# block passed in is the command itself?
		assert valid?

		pid = Process.fork do
			@block.call(*args)
		end

		assert valid?

		return pid
	end

	def wait(pid)
		# waits until forked process has finished executing
		Process.wait(pid)
	end
end
