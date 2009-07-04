Gem::Specification.new do |s|
  
  s.name = "discogs"
  s.version = "0.3"
  s.date = "2009-07-04"
  s.summary = "Discogs::Wrapper is a full wrapper for the http://www.discogs.com API"
  s.homepage = "http://www.github.com/buntine/discogs"
  s.email = "info@andrewbuntine.com"
  s.authors = ["Andrew Buntine"]
  
  s.description = "Discogs::Wrapper is a full wrapper for the http://www.discogs.com API"
  
  s.files = FileList["{lib}/**/*", "Rakefile", "README", "discogs.gemspec"].to_a
  s.test_files = FileList["{spec}/**/*spec.rb", "{spec}/**/*helper.rb"].to_a

  s.platform = Gem::Platform::RUBY

end
