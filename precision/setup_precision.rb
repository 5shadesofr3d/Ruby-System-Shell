# This script runs the following commands in sequence:
# swig -c++ -ruby precision.i
# ruby gen_makefile.rb
# make

system("swig -c++ -ruby precision.i")
system("ruby gen_makefile.rb")
system("make")