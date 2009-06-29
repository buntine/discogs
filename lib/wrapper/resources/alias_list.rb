# Represents a list of aliases in the Discogs API.

require File.dirname(__FILE__) + "/artist"
require File.dirname(__FILE__) + "/abstract_list"

class Discogs::Artist::AliasList < Discogs::Resource

  include Discogs::AbstractList

  map_to :aliases
  map_to_plural :aliases

end
