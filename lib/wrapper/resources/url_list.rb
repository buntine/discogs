# Represents a list of URLs in the Discogs API.

require File.dirname(__FILE__) + "/abstract_list"

class Discogs::URLList < Discogs::Resource

  include Discogs::AbstractList

  map_to :urls
  map_to_plural :urls

end
