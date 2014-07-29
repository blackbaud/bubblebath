require 'singleton'
require 'logger'
require 'yaml'
require_relative 'logger_extensions'
require 'bubblebath/exceptions'


module Bubblebath

  class Configuration
    include Singleton

    def initialize
      @settings = {}
      @runtime_defaults = {}
      reload
    end

    def defaults
      {
          :configfile => nil,
          :hostname => nil,
          :email => 'devnull',
          :closebrowseronexit => false,
          :loglevel => Logger::INFO,
          :uuid => nil,
          :webdriver => :firefox,
          # database
          :dbhostname => nil,
          :dbusername => nil,
          :dbpassword => nil,
          :dbsid => nil,
          :dbport => nil,
          # snapshots
          :snapshotwidth => 1000,
          :snapshotheight => 1000,
          :projectpath => nil,
      }.merge @runtime_defaults
    end

    def defaults=(x)
      @runtime_defaults.merge! x
      reload
      if !(/(bubblebath)/.match(caller.first).to_s === "bubblebath")
        self.logger.level = self.loglevel
      end
    end

    def update(values)
      values.each_pair { |k, v|
        v = Logger.const_get(v.upcase) if k.to_s == "loglevel" && v.class == String
        self[k] = v
      }
    end

    def inspect
      @settings.inspect
    end

    def reset
      @settings.each_key { |key| @settings.delete key }
    end

    def log_location
      log_location ||= Bubblebath::Configuration.instance.logging_location
    end

    def stdout
      if log_location == 'BOTH' or log_location == 'CONSOLE'
        STDOUT
      else
        "/dev/null"
      end
    end

    def [](key)
      @settings[key.to_sym]
    end

    def []=(key, value)
      override_method = "#{key}_value".to_sym
      if respond_to? override_method
        @settings[key.to_sym] = self.send override_method, value
      else
        @settings[key.to_sym] = value
      end
    end

    def method_missing(sym, *args)
      if sym.to_s =~ /(.+)=$/
        self[$1] = args.first
      else
        self[sym]
      end
    end


    # This will read in ANY variable set in a configuration file
    def read_from_file
      return unless File.exists?(configfile.to_s)
      filename = File.expand_path(configfile)
      case File.extname filename
        when ".yml"
          parse_yaml_file filename
        else
          Bubblebath.logger.warn "Unsure how to handle configuration file #{configfile}. Assuming .yml"
          parse_yaml_file filename
      end
    end

    alias :read :read_from_file

    # The variable needs to be set as a default here or in the
    # library to be read from the environment
    def read_from_environment
      @settings.each_key do |var|
        next if var.to_s.upcase == "USERNAME"
        next if var.to_s.upcase == "HOSTNAME" && self.hostname
        env = ENV[var.to_s.upcase]
        if var == :webdriver
          ENV['JOB_NAME']=~ /WEBDRIVER=(\w+)/
          env ||= $1
        end
        update_key var, env if env
      end
    end

    def reload
      update(defaults)
      read_from_file
      read_from_environment
      initialize_logger
    end

    def logger
      log_file_name = Bubblebath::Configuration.instance.log_file
      log_file_name ||= 'bubblebath.logs'
      log_file_path = "reports/logs/#{log_file_name}"
      unless File.exist?(File.dirname(log_file_path))
        FileUtils.mkdir_p(File.dirname(log_file_path))
      end
      @logger ||= begin
        log = Logger.new(stdout)
        if log_location == 'BOTH' or log_location == 'LOG_FILE'
          log.attach(log_file_path)
        end
        log.formatter = proc {|severity, datetime, progname, msg| "[#{datetime}] #{msg}\n"}
        log
      end
    end

    def loglevel=(x)
      logger.level = x
    end

    private

    def update_key key, value
      case value
        when 'true'
          update key.to_sym => true
        when 'false'
          update key.to_sym => false
        when /^:(.+)/
          update key.to_sym => $1.to_sym
        when /^\d+\s*$/
          update key.to_sym => value.to_i
        when /^(\d*\.\d+)\s*$/
          update key.to_sym => value.to_f
        else
          update key.to_sym => value
      end
    end

    def parse_yaml_file filename
      YAML.load_file(filename).each_pair { |key, value| update_key key, value }
    end

  end

  def self.logger
    Configuration.instance.logger ||= Logger.new(stdout)
  end
end

if File.exist?("#{File.dirname(__FILE__) + '/../..'}/config.yml")
  Bubblebath::Configuration.instance.defaults = {
      configfile:               "#{File.dirname(__FILE__) + '/../..'}/config.yml"
  }
  Bubblebath::Configuration.instance.reload
  Bubblebath::Configuration.instance.logger.info "Using configuration: #{Bubblebath::Configuration.instance.inspect}"
else
  raise ::Bubblebath::InvalidConfigurationFile.new "Expected config.yml not found in project root"
end