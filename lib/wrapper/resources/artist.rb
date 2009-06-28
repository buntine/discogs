# Represents an artist in the Discogs API.

class Discogs::Artist < Discogs::Resource

  attr_accessor :name,
                :realname,
                :images,
                :urls,
                :namevariations,
                :aliases,
                :members,
                :releases

end
