# Represents a track in the Discogs API.

require File.dirname(__FILE__) + "/release"
require File.dirname(__FILE__) + "/master_release"

class Discogs::Release::Track < Discogs::Resource

  map_to_plural :tracklist

  attr_accessor :position,
                :title,
                :duration,
                :artists,
                :extraartists

end

# Define other classes that also replicate this structure.
class Discogs::MasterRelease::Track < Discogs::Release::Track; end
