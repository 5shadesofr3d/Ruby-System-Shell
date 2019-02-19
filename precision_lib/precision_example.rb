require_relative 'precision'

# setup steps:
# swig -c++ -ruby precision.i
# ruby gen_makefile.rb
# make
# ruby precision_example.rb

def print_stuff
	puts "timer completed"
end

Precision::timer(3, print_stuff)
