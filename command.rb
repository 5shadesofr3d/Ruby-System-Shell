class Command
  def execute(&block)
    #block passed in is the command itself?
    block.call
    #verify stuff before and after block call
  end
end
