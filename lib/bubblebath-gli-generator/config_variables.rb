module BubblebathGliGenerator
  class ConfigVariables
    def self.initialize(project_name,file_name)
      @module_name = 'Bubblebath'
      @project_name = project_name
      @class_name = camelize(file_name)
      @current_directory = Dir.pwd
    end

    def self.file_name(file_path)
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

    # https://www.ruby-forum.com/topic/4411006
    def self.camelize(string_input)
      string_input.split('_').each { |s| s.capitalize! }.join('')
    end

    def self.valid_name(file_name)
      file_name =~ /^[a-zA-Z0-9_-]+$/
    end

    def self.model_class_name
      "#{@class_name}Model"
    end

    def self.view_class_name
      "#{@class_name}View"
    end

    def self.controller_class_name
      "#{@class_name}"
    end

    def self.module_name
      @module_name
    end
  end
end