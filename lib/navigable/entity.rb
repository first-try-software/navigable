module Navigable
  module Entity
    def self.extended(base)
      base.class_eval do
        def valid?
          true
        end

        def attributes
          self.class.attr_accessors.each_with_object({}) do |accessor, attributes|
            attributes[accessor] = public_send(accessor)
          end
        end

        def merge(new_attributes)
          self.class.new(attributes.merge(new_attributes))
        end

        def to_s
          "#{self.class.name}: #{attributes}"
        end

        def to_json(*args)
          attributes.to_json(*args)
        end
      end
    end

    def attr_accessor(*attrs)
      attr_accessors.push(*attrs)
      super
    end

    def attr_accessors
      @attr_accessors ||= []
    end
  end
end
