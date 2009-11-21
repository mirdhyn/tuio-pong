class Dependencity
  attr_reader :directories
  
  def initialize
    @directories = Array.new
    @ignore_list = Array.new
    @patterns = Array.new   # Priorities
  end
  
  # Add files for exclusion from loading. 
  def ignore name
    @ignore_list << name
  end
  
  # Add directories to load
  def add_dir name
    @directories << name
  end
  
  # Go through each pattern starting from the first element of the array
  def add_rule name
    @patterns << name
  end
  
  # Get a list of ruby files and then sorting them alphabetically
  def get_files directory
    files = Dir.glob( directory + "/" + File.join("**","*.rb")).sort()
    return files
  end
  
  # Shift an element of the array to the front. In that way, the loader will process the desired file first. 
  def move_to_front files, value
    filename = files[value]
    files.delete_at(value)    #Remove the filename in question
    files.unshift(filename) #Added the filename back in again, this time in the front.
  end
  
  # Processe rules in the order of the last and then the next last rule
  # ... so that the lower priority files will not overtake higher prority files
  def process_rules files
    go_down = @patterns.length()
    step = @patterns.length() - 1
    go_down.times do |rule|
      counter = 0
      files.each do |file|
        if file.match(@patterns[step])
          files = move_to_front(files,counter)
        end
        counter += 1
      end
      step -= 1
    end
    return files
  end
  
  # When done with sorting, load these files.
  def require_all files
    files.each do |file|
      action = true
      @ignore_list.each do |ignore|
        if file == ignore
          action = false
        end
      end
      if action == true
        require file
        puts"Loaded file: #{file}"
      end
    end
  end
  
  # After neccesary ingradient gathered, make use of everything else to do require on a directory scale. 
  def load_directory directory
    files = get_files(directory)
    files = process_rules(files)
    require_all(files)
  end

  # process a directory by getting all the filenames, sort them alpahbetically,
  # and reorder them to priority, load them, before moving on to the next directory in the list
  def process_directories
    @directories.each do |directory|
      load_directory(directory)
    end
  end
  
end
