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
  end

end

require File.dirname(__FILE__) + "/release"
