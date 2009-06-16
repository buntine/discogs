# Represents a track in the Discogs API.

class Discogs::Release::Track < Discogs::Resource

  map_to_plural :tracklist

  attr_accessor :position,
                :title,
                :duration

end
