# Represents a list of descriptions in the Discogs API.

class Discogs::DescriptionList < Discogs::Resource

  map_to :descriptions

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
