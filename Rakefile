require 'rake'
require 'rspec'
require 'rspec/core/rake_task'
require 'rubygems/package_task'



desc "Run all specs in spec directory"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = ["--colour"]
  t.pattern = 'spec/**/*_spec.rb'
end

desc "Run all specs and generate simplecov report"
task :cov do |t|
  ENV['COVERAGE'] = 'true'
  Rake::Task["spec"].execute
  `open coverage/index.html`
end

spec = eval(File.read("discogs.gemspec"))
 
Gem::PackageTask.new(spec) do |pkg|
  # pkg.need_zip = true
  # pkg.need_tar = true
end
