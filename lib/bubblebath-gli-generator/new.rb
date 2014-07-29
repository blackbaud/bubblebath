# http://stackoverflow.com/questions/980547/how-do-i-execute-ruby-template-files-erb-without-a-web-server-from-command-line
# http://ruby-doc.org/stdlib-2.1.2/libdoc/erb/rdoc/ERB.html
# http://ruby-doc.org/stdlib-1.9.3/libdoc/fileutils/rdoc/FileUtils.html
# http://ruby.about.com/od/beginningruby/a/dir1.htm

require 'fileutils'
require 'erb'
require 'savon'
require 'json'
require 'yaml'
module BubblebathGliGenerator

  class Project

    attr_accessor :filename, :wsdl, :class_names, :param_instance_variables, :services, :service_keys, :service_values, :service_key, :port_key, :operations, :operation_params

    def self.initialize(file_name, wsdl = nil, project_name)
      @filename = file_name
      @wsdl = wsdl

      if project_name.nil?
        @project_name = 'webservice'
      else
        @project_name = project_name
      end

      @client = Savon.new(wsdl)
      @services = client.services
      @service_keys = services.keys
      @operations = Hash.new
      @operation_params = Hash.new

      @service_keys.each do |service_key|
        service_values = services.values_at(service_key)
        service_values.each do |service_value|
          ports = service_value.values_at(:ports)
          ports.each do |port|
            port_keys = port.keys
            port_keys.each do |port_key|
              @operations[[service_key, port_key]] = client.operations(service_key, port_key)
              @operations[[service_key, port_key]].each do |operation|
                example_body = client.operation(service_key, port_key, operation).example_body
                example_body.keys.each do |example_body_key|
                  example_body.values_at(example_body_key).each do |example_body_value|
                    @operation_params[[service_key, port_key, operation]] = example_body_value.keys
                  end
                end
              end
            end
          end
        end
      end

      file_relative_path = File.dirname(__FILE__)
      current_directory = Dir.pwd
      @relative_path = "#{current_directory}/#{file_name}"
      @templates_path = "#{file_relative_path}/templates"
    end

    # https://www.ruby-forum.com/topic/4411006
    def self.camelize(string_input)
      string_input.split('_').each { |s| s.capitalize! }.join('')
    end

    def self.capcase(string_input)
      string_input = string_input.to_s
      string_input.split('').each { |s| s.capitalize! }.join
    end

    def self.underscore(string_input)
      string_input = string_input.to_s
      string_input.gsub(/::/, '/').
          gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
          gsub(/([a-z\d])([A-Z])/,'\1_\2').
          tr("-", "_").
          downcase
    end

    def self.valid_name(file_name)
      file_name =~ /^[a-zA-Z0-9_-]+$/
    end

    def self.project_name
      @project_name
    end

    def self.class_names
      @class_names
    end

    def self.wsdl
      @wsdl
    end

    def self.param_instance_variables
      @param_instance_variables
    end

    def self.services
      @services
    end

    def self.service_keys
      @service_keys
    end

    def self.service_key
      @service_key
    end

    def self.client
      @client
    end

    def self.port_key
      @port_key
    end

    def self.operations
      @operations
    end

    def self.operation_params
      @operation_params
    end

    def self.version_number
      @version_number
    end

    def self.create_directory(directory_path)
      if Dir.exist? directory_path
        puts "Directory already exist at path:'#{directory_path}'"
      else
        FileUtils.mkdir_p directory_path
      end
    end

    def self.process_erb_file(file_name_erb, file_name)
      if File.exist?(file_name)
        puts "File already exist at path:'#{file_name}'"
      else
        template_file = File.open(file_name_erb, 'r').read
        erb = ERB.new(template_file, nil, '%<>-')
        File.open(file_name, 'w+') { |file| file.write(erb.result(binding)) }
      end
    end

    def self.generate_erb_config_yml
      file_name_erb = template_path('config.yml.erb')
      file_name = relative_path('config.yml')
      process_erb_file(file_name_erb, file_name)
    end

    def self.generate_gemfile_rb
      file_name_erb = template_path('gemfile.rb.erb')
      file_name = relative_path('gemfile.rb')
      process_erb_file(file_name_erb, file_name)
    end

    def self.generate_rakefile_rb
      file_name_erb = template_path('rakefile.rb.erb')
      file_name = relative_path('rakefile.rb')
      process_erb_file(file_name_erb, file_name)
    end

    def self.generate_gitignore
      file_name_erb = template_path('.gitignore.erb')
      file_name = relative_path('.gitignore')
      process_erb_file(file_name_erb, file_name)
    end

    def self.template_path(erb_file_name)
      "#{@templates_path}/#{erb_file_name}"
    end

    def self.relative_path(mvc_name)
      "#{@relative_path}/#{mvc_name}"
    end

    # Create sample.feature files
    def self.generate_sample_features
      file_name_erb = template_path('features/sample.feature.erb')
      file_name = relative_path('features/sample.feature')
      process_erb_file(file_name_erb, file_name)
    end

    def self.generate_webservice_lib
      file_name_erb = template_path('features/webservice_lib.rb.erb')
      file_name = relative_path("lib/#{@project_name}.rb")
      process_erb_file(file_name_erb, file_name)
    end

    def self.generate_service_spec
      file_name_erb = template_path('features/service_test_spec.rb.erb')
      file_name = relative_path('spec/service_test_spec.rb')
      process_erb_file(file_name_erb, file_name)
    end

    def self.generate_spec_helper
      file_name_erb = template_path('features/spec_helper.rb.erb')
      file_name = relative_path('spec/spec_helper.rb')
      process_erb_file(file_name_erb, file_name)
    end

    def self.generate_webservice_soap_api
      file_name_erb = template_path("lib/webservice_soap_api.rb.erb")
      file_name = relative_path("lib/#{@project_name}/site/soap_api.rb")
      process_erb_file(file_name_erb, file_name)
    end

    # Create Directories
    def self.create_data_directory
      data_directory_path = relative_path('data')
      create_directory(data_directory_path)
    end

    def self.create_features_directory
      features_directory_path = relative_path('features')
      create_directory(features_directory_path)
      generate_sample_features
    end

    def self.generate_soap_operations(service_key)
      @service_key = service_key
      @services.values_at(service_key).each do |service_value|
        service_value.values_at(:ports).each do |ports|
          ports.keys.each do |port_key|
            @port_key = port_key
            if ports.keys.index(port_key) == 0
              file_name = relative_path("lib/#{@project_name}/workflows/#{service_key}/soap_operations.rb")
            else
              @version_number = ports.keys.index(port_key)+1
              file_name = relative_path("lib/#{@project_name}/workflows/#{service_key}/soap_operations#{@version_number}.rb")
            end
            file_name_erb = template_path('lib/soap_api.rb.erb')
            process_erb_file(file_name_erb, file_name)
          end
        end
      end
    end

    def self.generate_core_libraries
      file_name_erb = template_path('features/core_libraries.rb.erb')
      file_name = relative_path("lib/#{project_name}/core_libraries.rb")
      process_erb_file(file_name_erb, file_name)
    end

    def self.generate_protocol
      file_name_erb = template_path('features/protocol.rb.erb')
      file_name = relative_path("lib/#{project_name}/site/protocol.rb")
      process_erb_file(file_name_erb, file_name)
    end

    def self.create_service_directories
      @service_keys.each do |service_key|
        client_directory_path = relative_path("lib/#{@project_name}/workflows/#{service_key}")
        create_directory(client_directory_path)
        generate_soap_operations(service_key)
      end
    end

    def self.create_workflows_directory
      workflows_directory_path = relative_path("lib/#{@project_name}/workflows")
      create_directory(workflows_directory_path)
      create_service_directories
    end

    def self.create_site_directory
      site_directory_path = relative_path("lib/#{@project_name}/site")
      create_directory(site_directory_path)
      generate_webservice_soap_api
      generate_protocol
    end

    def self.create_project_directory
      project_directory_path = relative_path("lib/#{@project_name}")
      create_directory(project_directory_path)
      create_site_directory
      create_workflows_directory
      generate_core_libraries
    end

    def self.create_lib_directory
      lib_directory_path = relative_path('lib')
      create_directory(lib_directory_path)
      create_project_directory
      generate_webservice_lib
    end

    def self.create_spec_directory
      spec_directory_path = relative_path('spec')
      create_directory(spec_directory_path)
      generate_service_spec
      generate_spec_helper
    end

    def self.new(file_name, wsdl, project_name = nil)

      initialize(file_name, wsdl, project_name)

      create_directory(@relative_path)

      #create directories
      create_data_directory
      create_features_directory
      create_lib_directory
      create_spec_directory

      # generate files
      generate_erb_config_yml
      generate_gemfile_rb
      generate_rakefile_rb
      generate_gitignore

      # generate tree view
      tree_view = TreeView.new
      tree_view.print(@relative_path)
    end
  end
end
