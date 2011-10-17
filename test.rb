#! /usr/bin/env ruby

require 'lib/discogs'

wrapper = Discogs::Wrapper.new("buntine-test-app")

artist = wrapper.get_artist("Master's Hammer")
release = wrapper.get_release("611973") # Supply an ID.
puts release.title
puts artist.name                         # => "Master's Hammer"
#puts artist.releases[0].title            # => "Finished"
#puts artist.releases[1].year             # => "1989"
#puts artist.releases[4].extraartists     # => [ "Arakain", "Debustrol" ]
