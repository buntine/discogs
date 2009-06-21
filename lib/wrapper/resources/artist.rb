# Represents an artist in the Discogs API.

class Discogs::Artist < Discogs::Resource

  map_to_plural :artists, :extraartists

  attr_accessor :name

end
