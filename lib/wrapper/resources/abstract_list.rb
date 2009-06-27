# Represents a list of an unmanaged resource in the Discogs API.

module Discogs::AbstractList

  # Overload build method to provide custom process for
  # converting contents into something useful.
  def build!
    items = []
    document = REXML::Document.new(@content)

    document.root.each_element do |element|
      items << element.text
    end

    items
  end

end
