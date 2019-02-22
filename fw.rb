require_relative 'filewatch/file_watcher'

# FW stands for FILE WATCHER
# this program observes a list of files for alterations
# and performs a given action when the file is altered
# example usage: ruby fw.rb -f test -t 6000 -d "ls"

file_watcher = FileWatcher.new(ARGV)
file_watcher.watch