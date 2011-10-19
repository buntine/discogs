# Abstracts the resource-mapping class methods. 
#
# Each "resource" in the wrapper maps to one or more elements 
# in the API response. This way they can be recursively built
# without having to manually specify it in each class.

module Discogs::ResourceMappings

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods

    # Helper method to map resource to an element in the API response.
    def map_to(*elements)
      self.class_eval <<-EOF
        def self.element_names
          #{elements.inspect}
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

    # Used by root classes (Discogs::Artist, etc) that should be built internally.
    def no_mapping
      self.class_eval <<-EOF
        def self.element_names; []; end
        def self.plural_element_names; []; end
      EOF
    end

    # Element defaults to prevent excess boilerplate code.
    def element_names
      [ self.to_s.split("::")[-1].downcase.to_sym ]
    end
    def plural_element_names
      [ (self.element_names[0].to_s + "s").to_sym ]
    end

  end

 private

  def find_resource_for_name(name, type=:singular)
    method = if type == :singular
      :element_names
    else
      :plural_element_names
    end

    find_resource do |klass|
      klass.constants.find do |const|
        if klass.const_get(const).respond_to? method
          klass.const_get(const).send(method).any? { |element| element.eql?(name) }
        end
      end
    end
  end

  # Look in _namespace_ for a matching resource class.
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
