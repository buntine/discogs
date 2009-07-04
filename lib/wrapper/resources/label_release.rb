# Represents a labels release in the Discogs API.

require File.dirname(__FILE__) + "/label"

class Discogs::Label::Release < Discogs::Resource

  attr_accessor :id,
                :status,
                :type,
                :catno,
                :artist,
                :title,
                :format,
                :year,
                :trackinfo

end
