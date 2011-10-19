#! /usr/bin/env ruby

require 'lib/discogs'

wrapper = Discogs::Wrapper.new("buntine-test-app")

artist = wrapper.get_artist("Master's Hammer")
release = wrapper.get_release("611973") # Supply an ID.
master_release = wrapper.get_master_release("6119") # Supply an ID.

puts release.title
puts artist.name
puts artist.releases[0].title
puts release.styles.inspect
puts artist.releases[0].year
puts artist.releases[1].title
puts master_release.main_release
puts master_release.styles
