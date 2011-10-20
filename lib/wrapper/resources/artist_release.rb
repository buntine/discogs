# Represents an artist's release in the Discogs API.

require File.dirname(__FILE__) + "/artist"

class Discogs::Artist::Release < Discogs::Resource

  attr_accessor :id,
                :status,
                :role,
                :title,
                :artist,
                :format,
                :year,
                :label,
                :trackinfo

end
