# Represents a list of styles in the Discogs API.

require File.dirname(__FILE__) + "/release"
require File.dirname(__FILE__) + "/abstract_list"

class Discogs::Release::StyleList < Discogs::Resource

  include Discogs::AbstractList

  map_to :styles
  map_to_plural :styles

end
