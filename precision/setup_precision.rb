# This script runs the following commands in sequence:
# swig -c++ -ruby precision.i
# ruby gen_makefile.rb
# make

require_relative "../shell/shell"

shell = Shell.new
shell.execute("swig", "-c++", "-ruby", "precision.i")
shell.execute("ruby", "gen_makefile.rb")
shell.execute("make", [])