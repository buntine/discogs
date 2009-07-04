Gem::Specification.new do |s|
  
  s.name = "discogs"
  s.version = "0.3"
  s.date = "2009-07-04"
  s.summary = "Discogs::Wrapper is a full wrapper for the http://www.discogs.com API"
  s.homepage = "http://www.github.com/buntine/discogs"
  s.email = "info@andrewbuntine.com"
  s.authors = ["Andrew Buntine"]
  
  s.description = "Discogs::Wrapper is a full wrapper for the http://www.discogs.com API"
  
  s.files = ["lib/wrapper", "lib/wrapper/resource_mappings.rb", "lib/wrapper/wrapper.rb", "lib/wrapper/resource.rb", "lib/wrapper/resources", "lib/wrapper/resources/format.rb", "lib/wrapper/resources/search.rb", "lib/wrapper/resources/label_release.rb", "lib/wrapper/resources/artist.rb", "lib/wrapper/resources/release_artist.rb", "lib/wrapper/resources/artist_release.rb", "lib/wrapper/resources/release_label.rb", "lib/wrapper/resources/generic_list.rb", "lib/wrapper/resources/search_result.rb", "lib/wrapper/resources/label.rb", "lib/wrapper/resources/image.rb", "lib/wrapper/resources/track.rb", "lib/wrapper/resources/release.rb", "lib/discogs.rb", "Rakefile", "README", "discogs.gemspec"]

  s.test_files = ["spec/wrapper_methods/get_release_spec.rb", "spec/wrapper_methods/search_spec.rb", "spec/wrapper_methods/get_artist_spec.rb", "spec/wrapper_methods/get_label_spec.rb", "spec/resource_spec.rb", "spec/resources/label_spec.rb", "spec/resources/generic_list_spec.rb", "spec/resources/artist_release_spec.rb", "spec/resources/artist_spec.rb", "spec/resources/release_artist_spec.rb", "spec/resources/search_spec.rb", "spec/resources/label_release_spec.rb", "spec/resources/release_label_spec.rb", "spec/resources/release_spec.rb", "spec/resources/search_result_spec.rb", "spec/resources/image_spec.rb", "spec/resources/track_spec.rb", "spec/resources/format_spec.rb", "spec/wrapper_spec.rb", "spec/spec_helper.rb"]

  s.platform = Gem::Platform::RUBY

end
