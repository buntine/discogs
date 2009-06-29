# Represents a list of artist name variations in the Discogs API.

require File.dirname(__FILE__) + "/artist"
require File.dirname(__FILE__) + "/abstract_list"

class Discogs::Artist::NameVariationList < Discogs::Resource

  include Discogs::AbstractList

  map_to :namevariations
  map_to_plural :namevariations

end
