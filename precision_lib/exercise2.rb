require_relative 'precision'

time, message = ARGV
time = time.to_i

Precision::timer_ms(time, Proc.new { puts message })