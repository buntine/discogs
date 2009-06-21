# Abstracts the resource-mapping class methods. 

module Discogs::ResourceMappings

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods

    # Helper method to map resource to element in API response.
    def map_to(element)
      self.class_eval <<-EOF
        def self.element_name
          #{element.to_sym.inspect}
        end
      EOF
    end

    # Helper method to map pluralised resource to element in API response.
    def map_to_plural(*elements)
      self.class_eval <<-EOF
        def self.plural_element_names
          #{elements.inspect}
        end
      EOF
    end

    # Element defaults to prevent excess boilerplate code.
    def element_name
      self.to_s.split("::")[-1].downcase.to_sym
    end
    def plural_element_names
      [ (self.element_name.to_s + "s").to_sym ]
    end

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
    find_match = lambda do |klass|
      klass.constants.find do |const|
        klass.const_get(const).respond_to? :plural_element_names and klass.const_get(const).plural_element_names.any? { |plural_name| plural_name.eql?(name) }
      end
    end

    match = find_match.call(self.class)
    return self.class.const_get(match) if match

    match = find_match.call(Discogs)
    return Discogs.const_get(match) if match

    nil
  end

end
