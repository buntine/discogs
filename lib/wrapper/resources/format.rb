# Represents a release format in the Discogs API.

require File.dirname(__FILE__) + "/release"

class Discogs::Release::Format < Discogs::Resource

  attr_accessor :name,
                :qty,
                :descriptions

end
