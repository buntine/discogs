# Represents a list of genres in the Discogs API.

require File.dirname(__FILE__) + "/release"
require File.dirname(__FILE__) + "/abstract_list"

class Discogs::Release::GenreList < Discogs::Resource

  include Discogs::AbstractList

  map_to :genres
  map_to_plural :genres

end
