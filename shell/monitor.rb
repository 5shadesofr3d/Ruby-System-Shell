require 'test/unit'
require 'thread'

class ProcessInfo
	# Container for holding process data
	include Test::Unit::Assertions

	attr_reader :user, :pid, :ppid, :state, :started, :command
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
		return "#{@user} #{@pid} #{@ppid} #{@state} #{@started} #{@command}"
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

	attr_accessor :active

	def initialize(pid)
		assert (pid.is_a? Integer)

		@active = false
		@delay = 2.5 # seconds
		@pid = pid
		@processes = Hash.new
		@semaphore = Mutex.new

		@DEBUG_PRINT = false

		assert valid?
	end

	def valid?
		return false unless (@active == false or @active == true)
		return false unless (@delay.is_a? Float)
		return false unless (@pid.is_a? Integer)
		return false unless (@processes.is_a? Hash)
		return false unless (@semaphore.is_a? Mutex)

		return true
	end

	def run
		assert valid?

		@active = true

		while @active
			ps.each_line do |process|
				user, pid, ppid, state, started, cmd = process.split
				if ((@pid == pid.to_i) or (@processes.key? pid.to_i) or (@processes.key? ppid.to_i))
					if state == "Z"
						Process.wait(pid.to_i)
					else
						process = ProcessInfo.new(user, pid.to_i, ppid.to_i, state, started, cmd)
						@semaphore.lock
						@processes[pid.to_i] = process 
						@semaphore.unlock
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

	def ps
		rd, wr = IO.pipe
		pid = Process.fork do
			$stdout.reopen(wr)
			$stdin.close
			exec(*["ps", "-u", "#{Etc.getlogin}", "-o", "user,pid,ppid,state,start,cmd", "--sort", "start"])
		end
		wr.close
		data = rd.read
		rd.close
		Process.wait(pid)
		return data
	end

	def print_processes
		assert valid?
		@semaphore.lock
		
		@processes.each do |pid, process|
			puts process.to_s
		end

		@semaphore.unlock
		assert valid?
	end

	def cleanup_subtree
		assert valid?
		@semaphore.lock

		@processes.delete_if { |pid, process| (not process.checked) }

		@semaphore.unlock
		assert valid?
	end

	def clear_checks
		assert valid?
		@semaphore.lock

		@processes.each do |pid, process|
			process.checked = false
		end

		@semaphore.unlock
		assert valid?
	end

	def num_processes
		assert valid?

		return @processes.length
	end

	def cleanup
		return if @active

		assert valid?
		@semaphore.lock

		@processes.each do |pid, process|
			next if (pid == @pid) or (process.command == "ps")
			begin
				Process.kill("KILL", pid)
				Process.wait(pid)
			rescue Exception => e
				puts "Error: Unable to kill process pid: #{pid}, command: #{process.command}"
			end
		end
		@processes.clear

		@semaphore.unlock
		assert valid?
	end

end