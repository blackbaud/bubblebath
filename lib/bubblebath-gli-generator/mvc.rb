module BubblebathGliGenerator
  # Create new MVC project
  class MVC
    def self.initialize(directory_name, mvc_name)
      ConfigVariables.initialize(directory_name,mvc_name)
      @name = directory_name
      @mvc_name = mvc_name
      file_relative_path = File.dirname(__FILE__)
      current_directory = Dir.pwd
      @relative_path = "#{current_directory}"
      @templates_path = "#{file_relative_path}/templates/generators/mvc/templates"
    end

    def self.name
      Project.camelize(@name)
    end

    def self.directory_name(file_path)
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

    def self.create_project_name_directory_in_lib
      project_name = directory_name(@relative_path)
      directory_path = relative_path("lib/#{project_name}")
      Project.create_directory(directory_path)
      @relative_path = relative_path("lib/#{project_name}")
    end

    def self.create_mvc_directory(directory_name)
      directory_path = relative_path("#{directory_name}")
      Project.create_directory(directory_path)
      @relative_path = relative_path("#{directory_name}")
    end

    def self.generate_controller_rb(controller_name)
      file_name_erb = template_path('controller.rb.erb')
      file_name = relative_path("#{controller_name}.rb")
      Project.process_erb_file(file_name_erb, file_name)
    end

    def self.generate_view_rb(view_name)
      file_name_erb = template_path('view.rb.erb')
      file_name = relative_path("#{view_name}_view.rb")
      Project.process_erb_file(file_name_erb, file_name)
    end

    def self.generate_model_rb(model_name)
      file_name_erb = template_path('model.rb.erb')
      file_name = relative_path("#{model_name}_model.rb")
      Project.process_erb_file(file_name_erb, file_name)
    end

    def self.template_path(erb_file_name)
      "#{@templates_path}/#{erb_file_name}"
    end

    def self.relative_path(mvc_name)
      "#{@relative_path}/#{mvc_name}"
    end

    def self.new(directory_name,mvc_name)
      initialize(directory_name,mvc_name)
      create_project_name_directory_in_lib
      create_mvc_directory(directory_name)
      generate_controller_rb(mvc_name)
      generate_view_rb(mvc_name)
      generate_model_rb(mvc_name)
      tree_view = TreeView.new
      tree_view.print(@relative_path)
    end
  end
end
