require 'rubygems'
require 'bundler/setup'
require 'rake'
require 'rake/gempackagetask'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

gemspec = File.expand_path("../sitemap-builder.gemspec", __FILE__)
if File.exists? gemspec
  Rake::GemPackageTask.new(eval(File.read("sitemap-builder.gemspec"))) { |pkg| }
end

desc 'Test the sitemap_builder plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the sitemap_builder plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'SitemapBuilder'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = "sitemap-builder"
  gem.summary = "Rails plugins to build sitemap.xml"
  gem.description = "Rails plugins to build sitemap.xml"
  gem.email = "franck.dagostini@gmail.com"
  gem.homepage = "http://github.com/franck/sitemap-builder"
  gem.authors = ["Franck D'agostini"]
end