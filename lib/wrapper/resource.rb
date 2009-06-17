# Represents a generic resource in the Discogs API.

class Discogs::Resource

  def initialize(content)
    @content = content
  end

  # Helper method to map resource to element in API response.
  def self.map_to(element)
    self.class_eval <<-EOF
      def self.element_name
        "#{element.to_s}"
      end
    EOF
  end

  # Helper method to map pluralised resource to element in API response.
  def self.map_to_plural(element)
    self.class_eval <<-EOF
      def self.plural_element_name
        "#{element.to_s}"
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
      name = element.expanded_name
      setter = (name + "=").to_sym

      singular = find_resource_for_name(name)
      plural = singular ? nil : find_resource_for_plural_name(name)

      if !singular.nil?
        nested_object = singular.send(:new, element.to_s)
        self.send(setter, nested_object.build!)
      elsif !plural.nil?
        self.send(setter, [])
        element.each_element do |sub_element|
          nested_object = plural.send(:new, sub_element.to_s)
          self.send(name.to_sym) << nested_object.build!
        end
      elsif self.respond_to? setter
        self.send(setter, element.text)
      end
    end
 
    self
  end

 private

  def find_resource_for_name(name)
    find_match = lambda { |klass| klass.constants.find { |const| klass.const_get(const).respond_to? :element_name and klass.const_get(const).element_name == name } }
    match = find_match.call(self.class)
    return self.class.const_get(match) if match

    match = find_match.call(Discogs)
    return Discogs.const_get(match) if match

    nil
  end

  def find_resource_for_plural_name(name)
    find_match = lambda { |klass| klass.constants.find { |const| klass.const_get(const).respond_to? :plural_element_name and klass.const_get(const).plural_element_name == name } }
    match = find_match.call(self.class)
    return self.class.const_get(match) if match

    match = find_match.call(Discogs)
    return Discogs.const_get(match) if match

    nil
  end

end

Dir[File.join(File.dirname(__FILE__), "resources", "*.rb")].each { |file| require file }
