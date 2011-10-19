# Represents an release's artist in the Discogs API.

require File.dirname(__FILE__) + "/track"
require File.dirname(__FILE__) + "/master_release"

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
class Discogs::MasterRelease::Artist < Discogs::Release::Artist; end
class Discogs::MasterRelease::Track::Artist < Discogs::Release::Artist; end
