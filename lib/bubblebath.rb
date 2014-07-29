require 'soapui-util'

require 'bubblebath/utilities'
require 'bubblebath/exceptions'
require 'bubblebath/soap_api'
require 'bubblebath/savon_extensions'
require 'bubblebath/rest_api'
require 'bubblebath/configuration'

ENV['JAVA_HOME'] = Bubblebath::Configuration.instance.java_home