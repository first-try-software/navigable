module Navigable
  class Entity
    def self.inherited(child)
      child.instance_variable_set(:@attr_accessors, @attr_accessors)
    end

    def self.attr_accessor(*attrs)
      attr_accessors.push(*attrs)
      super
    end

    def self.attr_accessors
      @attr_accessors ||= []
    end

    attr_accessor :id, :created_at, :updated_at

    def initialize(params)
      @id = params[:id]
      @created_at = params[:created_at]
      @updated_at  = params[:updated_at]
    end

    def attributes
      self.class.attr_accessors.each_with_object({}) do |accessor, attributes|
        attributes[accessor] = public_send(accessor)
      end
    end

    def to_s
      "#{self.class.name}: #{attributes}"
    end
  end
end
