# Represents a release in the Discogs API.

class Discogs::Release < Discogs::Resource

  no_mapping

  attr_accessor :id,
                :master_id,
                :status,
                :title,
                :country,
                :released,
                :notes,
                :images,
                :videos,
                :artists,
                :extraartists,
                :labels,
                :formats,
                :styles,
                :genres,
                :tracklist

end
