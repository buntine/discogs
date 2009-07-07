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
  def build!(remove_resp=true)
    document = REXML::Document.new(@content, :ignore_whitespace_nodes => :all)
    root_node = document.root

    # Ignore the <resp> element if necessary.
    if remove_resp and document.root.expanded_name == "resp"
      root_node = root_node[0]
    end

    set_accessors_from_attributes(root_node)

    # Traverse node children.
    root_node.each_element do |element|
      name = element.expanded_name.to_sym
      setter = (name.to_s + "=").to_sym

      singular = find_resource_for_name(name, :singular)
      plural = singular ? nil : find_resource_for_name(name, :plural)

      # Create an instance of the named resource and build it.
      if !singular.nil?
        nested_object = singular.send(:new, element.to_s)
        self.send(setter, nested_object.build!)

      # Setup an array and build each child.
      elsif !plural.nil?
        set_accessors_from_attributes(element)

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

  def build_with_resp!
    build!(false)
  end

 private

  # Sets accessors on _self_ from the attributes of the given element.
  def set_accessors_from_attributes(element)
    element.attributes.each_attribute do |attribute|
      setter = (attribute.expanded_name + "=").to_sym

      if self.respond_to? setter
        self.send(setter, attribute.value)
      end
    end
  end

end

Dir[File.join(File.dirname(__FILE__), "resources", "*.rb")].each { |file| require file }
