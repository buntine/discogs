# Represents a Releases Label in the Discogs API.

require File.dirname(__FILE__) + "/release"

class Discogs::Release::Label < Discogs::Resource

  attr_accessor :catno,
                :name

end
