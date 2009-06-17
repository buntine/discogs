# Represents a list of styles in the Discogs API.

require File.dirname(__FILE__) + "/release"

class Discogs::Release::StyleList < Discogs::Resource

  map_to :styles

  # Overload build method to provide custom process for
  # converting contents into something useful.
  def build!
    styles = []
    document = REXML::Document.new(@content)

    document.root.each_element do |element|
      styles << element.text
    end

    styles
  end

end
