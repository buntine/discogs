# Represents a release identifier in the Discogs API.

require File.dirname(__FILE__) + "/release"

class Discogs::Release::Identifier < Discogs::Resource

  #no_mapping
  
  attr_accessor :type,
                :value,
                :description

end
