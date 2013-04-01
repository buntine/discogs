# Represents an video in the Discogs API.

class Discogs::Video < Discogs::Resource

  attr_accessor :duration,
                :embed,
                :description,
                :title,
                :uri

end
