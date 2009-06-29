require 'rake/testtask'
require 'rake/rdoctask'

task :default => :test

Rake::TestTask.new do |t|
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
end

namespace :docs do
  Rake::RDocTask.new('generate') do |rdoc|
    rdoc.title = 'Attribute-Views'
    rdoc.main = "README.rdoc"
    rdoc.rdoc_files.include('README.rdoc', 'lib')
    rdoc.options << "--all" << "--charset" << "utf-8"
  end
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "attribute-views"
    s.description = "A plugin converting between value objects and record columns."
    s.summary = "A plugin converting between value objects and record columns."
    s.email = "manfred@fngtps.com"
    s.homepage = "http://fingertips.github.com"
    
    s.authors = ["Manfred Stienstra"]
    s.files = %w(lib/active_record/attribute_views.rb rails/init.rb README.rdoc LICENSE)
  end
rescue LoadError
end

begin
  require 'jewelry_portfolio/tasks'
  JewelryPortfolio::Tasks.new do |p|
    p.account = 'Fingertips'
  end
rescue LoadError
end