# Represents a generic list of items in the Discogs API.

class Discogs::GenericList < Discogs::Resource

  map_to :descriptions, :genres, :aliases, :namevariations, :styles, :urls, :members

  map_to_plural :lists

  # Overload build method to provide custom process for
  # converting contents into something useful.
  def build!
    @items = []
    document = REXML::Document.new(@content)

    document.root.each_element do |element|
      @items << element.text
    end

    @items
  end

  # Provides post-build access to the list.
  def [](index)
    if @items.is_a?(Array)
      @items[index]
    end
  end

end
