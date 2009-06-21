# Represents a generic resource in the Discogs API.

require File.dirname(__FILE__) + "/resource_mappings"

class Discogs::Resource

  include Discogs::ResourceMappings

  def initialize(content)
    @content = content
  end

  def original_content
    @content
  end

  # Builds the resource with it's content.
  def build!
    document = REXML::Document.new(@content)
    root_node = (document.root.expanded_name == "resp") ? document.root[0] : document.root

    # Traverse node attributes.
    root_node.attributes.each_attribute do |attribute|
      setter = (attribute.expanded_name + "=").to_sym

      if self.respond_to? setter
        self.send(setter, attribute.value)
      end
    end

    # Traverse node children.
    root_node.each_element do |element|
      name = element.expanded_name.to_sym
      setter = (name.to_s + "=").to_sym

      singular = find_resource_for_name(name)
      plural = singular ? nil : find_resource_for_plural_name(name)

      if !singular.nil?
        nested_object = singular.send(:new, element.to_s)
        self.send(setter, nested_object.build!)
      elsif !plural.nil?
        self.send(setter, [])
        element.each_element do |sub_element|
          nested_object = plural.send(:new, sub_element.to_s)
          self.send(name) << nested_object.build!
        end
      elsif self.respond_to? setter
        self.send(setter, element.text)
      end
    end
 
    self
  end

end

Dir[File.join(File.dirname(__FILE__), "resources", "*.rb")].each { |file| require file }
