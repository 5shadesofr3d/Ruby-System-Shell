require_relative '../shell/shell'

def random_length_string(length)
  (0...length).map { ('a'..'z').to_a[rand(26)] }.join
end

def run_shell(command)
  shell = Shell.new
  shell.test_main(command)
end

def completely_random_tests(num_iterations)
  prng = Random.new

  for i in 0..num_iterations
    run_shell(prng.bytes(100))
  end

end

def random_string_tests(num_iterations)
  for i in 0..num_iterations
    run_shell(random_length_string(num_iterations))
  end
end

begin
  original_stderr = $stderr.clone
  original_stdout = $stdout.clone
  $stderr.reopen(File.new('/dev/null', 'w'))
  $stdout.reopen(File.new('/dev/null', 'w'))

  # Write random tests here...

  completely_random_tests(10) # We're getting a null byte error, can we fix this?
  random_string_tests(10)

rescue Exception => e
  $stdout.reopen(original_stdout)
  $stderr.reopen(original_stderr)
  raise e
ensure
  $stdout.reopen(original_stdout)
  $stderr.reopen(original_stderr)
end