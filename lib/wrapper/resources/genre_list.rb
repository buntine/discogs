# Represents a list of genres in the Discogs API.

require File.dirname(__FILE__) + "/release"

class Discogs::Release::GenreList < Discogs::Resource

  map_to :genres

  # Overload build method to provide custom process for
  # converting contents into something useful.
  def build!
    genres = []
    document = REXML::Document.new(@content)

    document.root.each_element do |element|
      genres << element.text
    end

    genres
  end

end
