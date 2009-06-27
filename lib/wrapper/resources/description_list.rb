# Represents a list of descriptions in the Discogs API.

require File.dirname(__FILE__) + "/abstract_list"

class Discogs::DescriptionList < Discogs::Resource

  include Discogs::AbstractList

  map_to :descriptions
  map_to_plural :descriptions

end
