require 'logger'
require 'xmlsimple'
require 'hashdiff'

module Utilities
  def log
    log = Bubblebath::Configuration.instance.logger
    log.level = Bubblebath::Configuration.instance.loglevel
    log
  end

  def local_ssl_ca_file
    file = Bubblebath::Configuration.instance.ssl_ca_file
    file_path = File.expand_path(Dir.pwd + file) unless file == nil
  end

  # note: it's bad practice to disable ssl verification! this is here for debugging purposes
  def verify_ssl?
    Bubblebath::Configuration.instance.verify_ssl == nil ? true : Bubblebath::Configuration.instance.verify_ssl
  end

  def wait_until_status_is(options={})
    operation = options[:operation]
    job_options = options[:job_options]
    expected_status = options[:expected_status]
    failure_status = options[:failure_status]
    time_limit = options[:time_limit]

    start_time = Time.now

    status_object = eval("#{operation}.new(#{job_options})")
    curr_status = status_object.result

    until curr_status == expected_status or curr_status == failure_status
      # we use this to gauge the progress of long running jobs
      time_elapsed = Time.now - start_time
      log.info("INFO: requested: '#{job_options}', current status: '#{curr_status}', time: #{time_elapsed}")

      if time_elapsed > time_limit
        raise Bubblebath::TestFailure, "Took more than #{time_limit} seconds. Last status at break point: #{curr_status}"
      end
      sleep 1
      
      # recreate the object to be able to call the new result
      status_object = eval("#{operation}.new(#{job_options})")
      
      curr_status = status_object.result
    end
    log.info("INFO: requested: '#{job_options}' reached status: '#{curr_status}', in #{time_elapsed} seconds")
    curr_status
  end

  def wsdl_diff(left_wsdl=nil, right_wsdl=nil)
    left_wsdl_results = XmlSimple.xml_in(left_wsdl)
    right_wsdl_results = XmlSimple.xml_in(right_wsdl)
    HashDiff.diff(left_wsdl_results, right_wsdl_results)
  end
end

