# Represents a label in the Discogs API.

class Discogs::Label < Discogs::Resource

  no_mapping

  attr_accessor :name,
                :contactinfo,
                :profile,
                :parentlabel,
                :images,
                :urls,
                :sublabels,
                :releases

end
