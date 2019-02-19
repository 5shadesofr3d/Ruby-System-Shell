require_relative 'precision'

# setup steps: (make sure you have swig, make, and ruby-dev on your PC!)
# swig -c++ -ruby precision.i
# ruby gen_makefile.rb
# make
# ruby precision_example.rb

def print_stuff
	puts "timer completed"
end

Precision::timer_ms(500, &print_stuff)
