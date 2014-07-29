require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

task default: :spec
task test: :spec

desc 'smoke soap test'
RSpec::Core::RakeTask.new do |t|
  t.pattern = 'spec/bubblebath/soap/*.rb'
end


require 'rubygems'
# require 'bundler'
# Bundler::GemHelper.install_tasks
#
# require 'rake/clean'
# CLEAN << FileList['pkg', 'coverage']
#
#
# require 'bubblebath/version'
#
# RSpec::Core::RakeTask.new(:spec)
#
# RSpec::Core::RakeTask.new(:rcov) do |t|
#   t.rcov = true
# end
#
#
#
# require 'rdoc/task'
# Rake::RDocTask.new do |rdoc|
#   rdoc.rdoc_dir = 'rdoc'
#   rdoc.title = "bubblebath #{Bubblebath::VERSION::STRING}"
#   rdoc.rdoc_files.include('README*')
#   rdoc.rdoc_files.include('lib/**/*.rb')
# end
#
# desc "deploy the gem to the gem server; must be run on on gem server"
# task :deploy => [:clean, :install] do
#   gemserver=ENV['GEM_SERVER']
#   ssh_options='-o User=root -o IdentityFile=~/.ssh/0-default.private -o StrictHostKeyChecking=no -o CheckHostIP=no -o UserKnownHostsFile=/dev/null'
#   temp_dir=`ssh #{ssh_options} #{gemserver} 'mktemp -d'`.strip
#   system("scp #{ssh_options} pkg/*.gem '#{gemserver}:#{temp_dir}'")
#   system("ssh #{ssh_options} #{gemserver} 'gem install --local --no-ri #{temp_dir}/*.gem --ignore-dependencies'")
#   system("ssh #{ssh_options} #{gemserver} 'rm -rf #{temp_dir}'")
# end



# require 'rake/clean'
# require 'rubygems'
# require 'rubygems/package_task'
# require 'rdoc/task'
# require 'cucumber'
# require 'cucumber/rake/task'
# Rake::RDocTask.new do |rd|
#   rd.main = "README.markdown"
#   rd.rdoc_files.include("README.markdown","lib/**/*.rb","bin/**/*")
#   rd.title = 'Your application title'
# end
#
# spec = eval(File.read('bubblebath.gemspec'))
#
# Gem::PackageTask.new(spec) do |pkg|
# end
# CUKE_RESULTS = 'results.html'
# CLEAN << CUKE_RESULTS
# desc 'Run features'
# Cucumber::Rake::Task.new(:features) do |t|
#   opts = "features --format html -o #{CUKE_RESULTS} --format progress -x"
#   opts += " --tags #{ENV['TAGS']}" if ENV['TAGS']
#   t.cucumber_opts =  opts
#   t.fork = false
# end
#
# desc 'Run features tagged as work-in-progress (@wip)'
# Cucumber::Rake::Task.new('features:wip') do |t|
#   tag_opts = ' --tags ~@pending'
#   tag_opts = ' --tags @wip'
#   t.cucumber_opts = "features --format html -o #{CUKE_RESULTS} --format pretty -x -s#{tag_opts}"
#   t.fork = false
# end
#
# task :cucumber => :features
# task 'cucumber:wip' => 'features:wip'
# task :wip => 'features:wip'
# require 'rake/testtask'
# Rake::TestTask.new do |t|
#   t.libs << "test"
#   t.test_files = FileList['test/*_test.rb']
# end
#
# task :default => [:test,:features]
