# Represents an video in the Discogs API.

class Discogs::Video < Discogs::Resource

  attr_accessor :uri,
                :duration,
                :embed,
                :description,
                :title,
                :src

end
