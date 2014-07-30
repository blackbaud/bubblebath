$:.unshift File.expand_path('../lib', __FILE__)
require 'bubblebath/version'

require 'bubblebath-gli-generator/tree-view.rb'
require 'bubblebath-gli-generator/config_variables.rb'

spec = Gem::Specification.new do |s|
  s.name                          = Bubblebath::VERSION::NAME
  s.version                       = Bubblebath::VERSION::STRING
  s.summary                       = Bubblebath::VERSION::SUMMARY
  s.authors                       = "member's of the mighty sandwich club!"
  s.email                         = 'cyrus'
  s.description                   = 'Generic interface for SOAP and REST api. Includes SOAP schema compliance validation.'
  s.homepage                      = 'https://github.com/sandwichclub/bubblebath'
  s.license                       = 'MIT'

  s.platform                      = Gem::Platform::RUBY
  #s.files                         = Dir.glob('{lib}/**/*')
  s.files                         = `git ls-files`.split("\n")
  s.test_files                    = Dir.glob('spec/*.rb')
  s.require_paths                 = ['lib']

  s.has_rdoc                      = true
  s.extra_rdoc_files              = 'README.md'
  s.rdoc_options                  << '--title' << 'bubblebath-gli-generator' << '--main' << 'README.markdown' << '-ri'
  s.bindir                        = 'bin'
  s.executables                   = 'bubblebath-gli-generator'

  s.add_runtime_dependency('httparty', ['~> 0.13.1'])
  s.add_runtime_dependency('xml-simple', ['~> 1.1.4'])
  s.add_runtime_dependency('hashdiff', ['~>0.2.1'])
  s.add_runtime_dependency('gli','2.10.0')
  s.add_development_dependency('rake', ['~>10.1'])
  s.add_development_dependency('rspec', ['~>2.12'])
  s.add_development_dependency('webmock', ['~> 1.18.0'])
  s.add_development_dependency('rdoc', ['~> 4.1.1'])
  s.add_development_dependency('aruba', ['~> 0.6.0'])
  s.add_development_dependency('bundler')
end