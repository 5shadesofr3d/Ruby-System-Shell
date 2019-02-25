require 'test/unit'

class ProcessInfo
	# Container for holding process data
	include Test::Unit::Assertions

	attr_reader :user, :pid, :ppid, :state, :started, :cmd
	attr_accessor :checked

	def initialize(user, pid, ppid, state, started, cmd)
		@user = user
		@pid = pid
		@ppid = ppid
		@state = state
		@started = started
		@command = cmd
		@checked = true

		assert valid?
	end

	def to_s
		assert valid?
		return "#{@user} #{@pid} #{@ppid} #{@state} #{@started} #{@cmd}"
	end

	def valid?
		return false unless @user.is_a? String
		return false unless @pid.is_a? Integer
		return false unless @ppid.is_a? Integer
		return false unless @state.is_a? String
		return false unless @started.is_a? String
		return false unless @command.is_a? String
		return false unless (@checked == false or @checked == true)

		return true
	end
end

class Monitor
	# Monitors all processes belonging to the specified pid tree
	include Test::Unit::Assertions

	def initialize(pid)
		assert (pid.is_a? Integer)

		@active = false
		@delay = 2.5 # seconds
		@pid = pid
		@processes = Hash.new

		@DEBUG_PRINT = true

		assert valid?
	end

	def valid?
		return false unless (@active == false or @active == true)
		return false unless (@delay.is_a? Float)
		return false unless (@pid.is_a? Integer)
		return false unless (@processes.is_a? Hash)

		return true
	end

	def run
		assert valid?

		@active = true

		while @active
			
			IO.popen("ps -u $USER -o user,pid,ppid,state,start,cmd --sort start") do |ps_io|
				ps = ps_io.read
				ps = ps.split("\n")

				ps.each do |process|
					user, pid, ppid, state, started, cmd = process.split
					if ((@pid == pid.to_i) or (@processes.key? pid.to_i) or (@processes.key? ppid.to_i))
						puts pid
						process = ProcessInfo.new(user, pid.to_i, ppid.to_i, state, started, cmd)
						@processes[pid.to_i] = process 
					end
				end

			end
			
			cleanup_subtree
			clear_checks
			print_processes if @DEBUG_PRINT
			sleep @delay
		end

		assert valid?
	end

	def print_processes
		@processes.each do |pid, process|
			puts process.to_s
		end
	end

	def cleanup_subtree
		@processes.delete_if { |pid, process| (not process.checked) }
	end

	def clear_checks
		@processes.each do |pid, process|
			process.checked = false
		end
	end

	def num_processes
		return @processes.length
	end

	def cleanup
		return if @active

		assert valid?

		@processes.each do |pid, process|
			Process.kill("SIGKILL", pid)
			Process.wait
		end
		@processes.cleanup

		assert valid?
	end

end