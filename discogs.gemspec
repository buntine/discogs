Gem::Specification.new do |s|
  
  s.name = "discogs-wrapper"
  s.version = "2.1.4"
  s.date = "2015-08-06"
  s.licenses = ["MIT"]
  s.summary = "Discogs::Wrapper is a full wrapper for the http://www.discogs.com API V2"
  s.homepage = "http://www.github.com/buntine/discogs"
  s.email = "info@andrewbuntine.com"
  s.authors = ["Andrew Buntine", "Many more contributors"]
  
  s.description = "Discogs::Wrapper is a full wrapper for the http://www.discogs.com API V2. Supports authentication, pagination, JSON."
  
  s.files = Dir.glob("{lib}/**/*") + %w(LICENSE README.markdown)

  s.test_files = Dir.glob("{spec}/**/*")

  s.platform = Gem::Platform::RUBY
  
  s.add_development_dependency "pry", "~> 0"
#  s.add_development_dependency "pry-na", "~> 0"
  s.add_development_dependency "rspec", "~> 3.3.0"
  s.add_development_dependency "simplecov", "= 0.7.1"
  
  s.add_runtime_dependency "hashie", "~> 3.0"
  s.add_runtime_dependency "oauth", "~> 0.4.7"

end
