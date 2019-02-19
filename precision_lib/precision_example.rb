require_relative 'precision'

# setup steps: (make sure you have swig, make, and ruby-dev on your PC!)
# swig -c++ -ruby precision.i
# ruby gen_makefile.rb
# make
# ruby precision_example.rb

def print_timer
	puts "timer_s completed"
end

def print_timer_ms
	puts "timer_ms completed"
end

def print_timer_us
	puts "timer_us completed"
end

def print_timer_ns
	puts "timer_ns completed"
end

Precision::timer(1, method(:print_timer))
Precision::timer_ms(500, method(:print_timer_ms))
Precision::timer_us(500, method(:print_timer_us))
Precision::timer_ns(500, method(:print_timer_ns))
