# Represents a generic resource in the Discogs API.

class Discogs::Resource

  def initialize(api_response)
    @api_response = api_response
  end

  # Helper method to map resource to element in API response.
  def self.map_to(element)
    self.class_eval <<-EOF
      def self.element_name
        "#{element}"
      end
    EOF
  end

  # Helper method to map pluralised resource to element in API response.
  def self.map_to_plural(element)
    self.class_eval <<-EOF
      def self.plural_element_name
        "#{element}"
      end
    EOF
  end

  # Element defaults to prevent excess boilerplate code.
  def self.element_name
    self.to_s.split("::")[-1].downcase
  end
  def self.plural_element_name
    self.element_name + "s"
  end

  def build!
    @api_response.root.each_element do |element|
      
    end

  # Strip <resp> element.
    # The build! method should (hopefully!) traverse the XML data and recursively build the object (and sub objects).
    # Known ttributes should be defined as assessors, and method_missing should catch all unknowns...
    # Elements which exist as objects (<label> == Discogs::Label) should be initialized and then built with said markup.
    # Pluralisations (+s, +list) of known objects should be set as arrays and then all children should be built into objects and have "build!" called with their respective markup.
    # Known Element classes should have an optional "map_to" class method that marries an xml element name to the object (Discog::Artist::MemberList will map to "members"). It will default to self.class.downcase.
    # Any class can overload "build!" method and return something useful. This will be handy if the markup should be parsed into something war (e.g: artist -> memberlist -> [name, name, name])
 
  end

end

require File.dirname(__FILE__) + "/release"
