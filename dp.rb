require_relative 'precision/precision'

# DP stands for DELAY PRINT
# this program prints a given message after a given time delay
# example usage: ruby dp.rb 1000 "Hello World"

time, message = ARGV
time = time.to_i

Precision::timer_ms(time, Proc.new { puts message })