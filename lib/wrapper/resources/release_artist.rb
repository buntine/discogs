# Represents an artist for a release in the Discogs API.

require File.dirname(__FILE__) + "/track"

class Discogs::Release::Artist < Discogs::Resource

  map_to_plural :artists, :extraartists

  attr_accessor :name,
                :role,
                :join,
                :anv,
                :tracks

end

# Define other classes that also replicate this structure.
class Discogs::Release::Track::Artist < Discogs::Release::Artist; end
