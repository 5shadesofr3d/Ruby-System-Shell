require_relative 'precision'

def print_stuff
	puts "timer completed"
end

Precision::timer(10*1000000000, print_stuff)
