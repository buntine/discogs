# Represents a release in the Discogs API.

class Discogs::Release < Discogs::Resource

  attr_accessor :id,
                :status,
                :title,
                :country,
                :released,
                :notes,
                :images,
                :artists,
                :labels,
                :formats,
                :styles,
                :genres,
                :tracklist

end
