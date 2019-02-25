require "test/unit"
require "colorize"

#Commands here will instantiate a command object then pass a block to it
module ShellCommands
  include Test::Unit::Assertions

  # NOTE: In some cases, the file directory string printed does not change. I think
  # this is a race condition between this function and the printing function.
  def self.cd(filepath = ENV["HOME"])
    begin
      Dir.chdir(filepath) # Slight bug, it breaks slightly when
    rescue SystemCallError
      puts "SystemCallError: Target directory '#{filepath}' does not exist.".red.bold
    end
  end

  def self.envar(*args)
    begin
      raise Exception, "No arguments supplied to env-var" if args.length == 0
      raise Exception, "Expected 1 or 3 arguments" if args.length > 3 or args.length == 2

      case args.length
      when 1
        key = args[0]
        
        if ENV[key] == nil
          raise Exception, "The key '#{key}' does not exist in the environment"
        else
          puts ENV[key]
        end

      when 3
        key, op, value = args
        
        if ENV[key] == nil
          raise Exception, "The key '#{key}' does not exist in the environment"
        end

        if op == "+"
          ENV[key] = "#{ENV[key]}#{value}"
        elsif op == "="
          ENV[key] = value
        else
          raise Exception, "Unknown operator '#{op}' specified. Please use + (append) or = (set)"
        end

      end
    rescue Exception => e
      puts e.message.red.bold
    end
  end

end