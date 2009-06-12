Gem::Specification.new do |s|
  
  s.name = "discogs-wrapper"
  s.version = "0.1"
  s.date = "2009-06-20"
  s.summary = "Discogs::Wrapper is a full wrapper for the http://www.discogs.com API"
  s.homepage = "https://www.andrewbuntine.com"
  s.email = "info@andrewbuntine.com"
  s.authors = ["Andrew Buntine"]
  
  s.description = <<-END
  END
  
  s.files = FileList["{lib}/**/*", "Rakefile", "discogs.gemspec"].to_a
  s.test_files = FileList["{spec}/**/*spec.rb", "{spec}/**/*helper.rb"].to_a

  s.platform = Gem::Platform::RUBY

end
