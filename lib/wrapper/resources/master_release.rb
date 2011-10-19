# Represents a release in the Discogs API.

class Discogs::MasterRelease < Discogs::Resource

  no_mapping

  attr_accessor :id,
                :styles,
                :genres,
                :main_release,
                :notes,
                :year,
                :images,
                :tracklist,
                :artists
                #:versions,
                #:videos
end
