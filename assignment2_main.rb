#Group Members
# Vishal Patel
# Rizwan Qureshi
# Curtis Goud
# Jose Ramirez
# Jori Romans

require_relative 'shell/shell'

shell = Shell.new
shell.start

# Setup steps:
# Ensure you have swig installed.
# To be able to run the "dp" command, do the following:
#   1. Go into the precision directory.
#   2. Run "ruby setup_precision.rb".
#   3. You can now use dp from the shell. Ex) dp 2000 "Hello, world!"