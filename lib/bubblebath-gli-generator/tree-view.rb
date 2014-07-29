# http://compsci.ca/v3/viewtopic.php?t=13034
module BubblebathGliGenerator
  # Print Tree View of a project
  class TreeView
    def print(relative_path)
      directory_name = directory_name(relative_path)
      directories_array = Pathname.new(relative_path).children.select { |c| c.directory? }
      print_directories(directory_name, directories_array)
      print_files(relative_path)
    end

    def print_directories(directory_name, directories_array)
      puts "[#{directory_name}]"
      directories_array.each do |directory|
        # print_tree(directory,0)
        print_dir_name_tree(directory, 1)
      end
    end

    def print_files(dir)
      Dir["#{dir}/*"].each do |f|
        puts "|-- #{File.basename(f)}" unless File.directory?(f)
      end
    end

    def directory_name(file_path)
      dir_name = ''
      file_path.each_char do |character|
        if character == '/'
          dir_name = ''
        else
          dir_name += character
        end
      end
      dir_name
    end

    def print_dir_name_tree(dir, nesting = 0)
      dir_name = directory_name(dir.to_s)
      puts '|   ' * nesting + "|-- #{dir_name}" if nesting < 2
      Dir.foreach(dir) do |entry|
        next if entry =~ /^\.{1,2}/   # Ignore ".", "..", or hidden files
        puts '|   ' * (nesting + 1) + "|-- #{entry}"
        if File.stat(d = "#{dir}#{File::SEPARATOR}#{entry}").directory?
          print_dir_name_tree(d, nesting + 1)
        end
      end
    end
  end
end
