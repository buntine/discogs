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
    # Traverse node attributes.
    @api_response.root[0].attributes.each_attribute do |attribute|
      setter = (attribute.expanded_name + "=").to_sym

      if self.respond_to? setter
        self.send(setter, attribute.value)
      end
    end

    # Traverse node children.
    @api_response.root[0].each_element do |element|
      name = element.expanded_name
      setter = (name + "=").to_sym

      singular = find_resource_for_name(name)
      plural = singular ? nil : find_resource_for_plural_name(name)

      if !singular.nil?
        false
      elsif !plural.nil?
        false
      elsif self.respond_to? setter
        self.send(setter, element.text)
      end
    end

  # Strip <resp> element.
    # The build! method should (hopefully!) traverse the XML data and recursively build the object (and sub objects).
    # Known ttributes should be defined as assessors, and method_missing should catch all unknowns...
    # Elements which exist as objects (<label> == Discogs::Label) should be initialized and then built with said markup.
    # Pluralisations (+s, +list) of known objects should be set as arrays and then all children should be built into objects and have "build!" called with their respective markup.
    # Known Element classes should have an optional "map_to" class method that marries an xml element name to the object (Discog::Artist::MemberList will map to "members"). It will default to self.class.downcase.
    # Any class can overload "build!" method and return something useful. This will be handy if the markup should be parsed into something war (e.g: artist -> memberlist -> [name, name, name])
 
    self
  end

 private

  def find_resource_for_name(name)
    nil
  end

  def find_resource_for_plural_name(name)
    nil
  end

end

require File.dirname(__FILE__) + "/release"
