# Represents a master release in the Discogs API.

class Discogs::MasterRelease < Discogs::Resource

  no_mapping

  attr_accessor :id,
                :styles,
                :genres,
                :main_release,
                :notes,
                :year,
                :images,
                :videos,
                :tracklist,
                :artists
                #:versions,
                #:videos
end
