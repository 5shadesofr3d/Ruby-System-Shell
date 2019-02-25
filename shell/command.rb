require 'test/unit'

class Command
	include Test::Unit::Assertions

	attr_reader :block, :nonblock

	def initialize(nonblock = false, &block)
		#pre
		assert ((nonblock == true) || (nonblock == false))
		assert block.is_a? Proc

		@nonblock = nonblock
		@block = block

		#post
		assert ((@nonblock == true) || (@nonblock == false))
		assert @block.is_a? Proc
		assert valid?
	end

	def valid?
		return false unless ((@nonblock == true) || (@nonblock == false))
		return false unless @block.is_a? Proc
		return true
	end

	def execute(*args)
		# block passed in is the command itself?
		#pre
		assert valid?

		thread = Thread.new do
			$SAFE = 1
			@block.call(*args)
		end


		#post
		assert thread.alive?
		assert valid?

		return thread
	end

	def call(*args)
		#pre
		assert valid?

		self.execute(*args)

		#post
		assert valid?
	end

	def wait(thread)
		#pre
		assert valid?
		assert thread.is_a? Thread
		assert thread.alive?

		# waits until thread has finished calling
		thread.join

		#post
		assert valid?
	end

	def nonblocking?
		#pre
		assert valid?
		assert ((@nonblock == true) || (@nonblock == false))

		return @nonblock
	end
end

class ForkCommand < Command
	def execute(*args)
		# block passed in is the command itself?
		# pre
		assert valid?

		pid = Process.fork do
			$SAFE = 1
			@block.call(*args)
		end

		#post
		assert pid >= 0 #negative pid means error occured
		assert valid?

		return pid
	end

	def wait(pid)
		# waits until forked process has finished executing
		#pre
		assert valid?
		assert pid.is_a? Numeric
		assert pid >= 0

		Process.wait(pid)

		#post
		assert valid?
	end
end


