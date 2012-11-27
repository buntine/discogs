require 'rake'
require 'rspec'
require 'rspec/core/rake_task'
require 'rake/gempackagetask'

task :default => :spec

desc "Run all specs in spec directory"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = ["--colour"]
  t.pattern = 'spec/**/*_spec.rb'
end

desc "Run all specs and generate RCov report"
RSpec::Core::RakeTask.new('cov') do |t|
  t.pattern = 'spec/**/*.rb'
  t.rspec_opts = ["--colour"]
  t.rcov = true
  t.rcov_opts = ['-T --no-html --exclude', 'spec\/,gems\/']
end

spec = eval(File.read("discogs.gemspec"))
 
Rake::GemPackageTask.new(spec) do |pkg|
  # pkg.need_zip = true
  # pkg.need_tar = true
end
