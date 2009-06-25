# Represents a track in the Discogs API.

require File.dirname(__FILE__) + "/release"

class Discogs::Release::Track < Discogs::Resource

  map_to_plural :tracklist

  attr_accessor :position,
                :title,
                :duration,
                :artists,
                :extraartists

end
