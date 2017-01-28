Gem::Specification.new do |s|
  
  s.name = "discogs-wrapper"
  s.version = "2.2.0"
  s.date = "2017-01-27"
  s.licenses = ["MIT"]
  s.summary = "Discogs::Wrapper is a full wrapper for the http://www.discogs.com API V2"
  s.homepage = "https://www.github.com/buntine/discogs"
  s.email = "info@bunts.io"
  s.authors = ["Andrew Buntine", "Many more contributors - see https://github.com/buntine/discogs/graphs/contributors"]
  
  s.description = "Discogs::Wrapper is a full wrapper for the http://www.discogs.com API V2. Supports authentication, pagination, JSON."
  
  s.files = Dir.glob("{lib}/**/*") + %w(LICENSE README.markdown)

  s.test_files = Dir.glob("{spec}/**/*")

  s.platform = Gem::Platform::RUBY
  
  s.add_development_dependency "pry", "~> 0"
  s.add_development_dependency "rspec", "~> 3.3"
  s.add_development_dependency "simplecov", "= 0.7.1"
  
  s.add_runtime_dependency "hashie", "~> 3.0"
  s.add_runtime_dependency "httparty", "~> 0.14"
  s.add_runtime_dependency "oauth", "~> 0.4.7"

end
