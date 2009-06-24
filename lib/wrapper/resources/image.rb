# Represents an image in the Discogs API.

class Discogs::Image < Discogs::Resource

  attr_accessor :uri,
                :uri150,
                :width,
                :height,
                :type

end
