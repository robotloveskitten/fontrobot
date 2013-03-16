# require 'rake'
require "bundler/gem_tasks"
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs = t.libs + ['lib/fontrobot', 'spec', 'spec/fixtures']
  t.test_files = FileList['spec/fontrobot/*_spec.rb']
  t.verbose = true
end

task :default => :test

