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
    find_resource do |klass|
      klass.constants.find do |const|
        if klass.const_get(const).respond_to? :element_name
          klass.const_get(const).element_name == name
        end
      end
    end
  end

  # Searches through resource classes looking for a plural match for _name_.
  def find_resource_for_plural_name(name)
    find_resource do |klass|
      klass.constants.find do |const|
        if klass.const_get(const).respond_to? :plural_element_names
          klass.const_get(const).plural_element_names.any? { |plural_name| plural_name.eql?(name) }
        end
      end
    end
  end

  # Find a resouce class
  # First looks in the children of _self_ namespace, and then looks more 
  # generally. Returns nil if nothing is found.
  def find_resource(namespace=self.class, &matcher)
    match = matcher.call(namespace)

    if match
      match = namespace.const_get(match)
    elsif namespace == self.class
      match = find_resource(Discogs, &matcher)
    end

    return match
  end

end
