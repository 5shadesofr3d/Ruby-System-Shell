class FileWatch
  def initialize(alteration, duration, files)
    @duration = duration
    @files = files

    if alteration == "-d"
      @alteration = "fileDestroyed?"
    elsif alteration == "-a"
      @alteration = "fileChanged?"
    else
      @alteration = "fileCreated?"
    end

    @watchList = self.createWatchList

    while true
      for watcher in @watchList
        if watcher.send(@alteration)
          #In place of object execution code for now...
          print "There was a change in #{watcher.file}\n"
        end
      end
    end
  end

  def createWatchList
    watchList = []
    for file in @files
      watchList += [Watcher.new(file)]
    end
    return watchList
  end

end


class Watcher
  def initialize(file)
    @file = file
    @timeAltered = self.calculateLastAlteredTime
    @exists = self.calculateFileExists

  end

  def file
    return @file
  end

  def calculateLastAlteredTime
    begin
      aTime = File.stat(@file).atime
    rescue
      aTime = Time.new(0)
    end
    return aTime
  end

  def calculateFileExists
    doesFileExist = true
    begin
      File::Stat.new(@file)
    rescue
      doesFileExist = false
    end
    return doesFileExist
  end

  def fileCreated?
    oldExistsStatus = @exists
    @exists = self.calculateFileExists

    if @exists and !oldExistsStatus
      return true
    end
    return false
  end

  def fileDestroyed?
    oldExistsStatus = @exists
    @exists = self.calculateFileExists

    if !@exists and oldExistsStatus
      return true
    end
    return false
  end

  def fileChanged?
    oldTime = @timeAltered
    @timeAltered = self.calculateLastAlteredTime

    # No change
    if oldTime == @timeAltered
      return false
    else
      return true
    end
  end
end



