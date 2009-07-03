# Represents a single search result in the Discogs API.

require File.dirname(__FILE__) + "/search"

class Discogs::Search::Result < Discogs::Resource

  map_to_plural :exactresults, :searchresults

  attr_accessor :num,
                :type,
                :title,
                :uri,
                :anv,
                :summary

end
