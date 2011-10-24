# Represents an master release version in the Discogs API.

require File.dirname(__FILE__) + "/master_release"

class Discogs::MasterRelease::Version < Discogs::Resource

  attr_accessor :id,
                :status,
                :title,
                :format,
                :label,
                :catno,
                :country,
                :released,
                :thumb

end
