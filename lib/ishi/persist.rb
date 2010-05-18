require 'thread'
require 'fileutils'

module Ishi
  module Persist
    def self.included(base)
      base.extend ClassMethods
      base.module_eval{include InstanceMethods}
      super

      # generate an accessor for `id` unless the class implements it
      # FIXME: this is probably busted if models are subclassed
      unless base.instance_methods(false).include?('id')
        base.class_eval do
          attr_accessor :id
        end
      end

      Ishi.datastore.init_class(base)
    end

    module ClassMethods
      def load(id)
        Ishi.datastore.retrieve_object_by_class_and_id(self, id)
      end
    end

    module InstanceMethods
      def save!
        Ishi.datastore.store_object(self)
        return true
      end

      # Returns the contents of the record as a nicely formatted string.
      def inspect
        attributes_for_inspect = self.attributes.collect do |attr|
          "#{attr}: " + self.instance_variable_get("@#{attr}").to_s
        end.join(", ")
        return "#<#{self.class} #{attributes_for_inspect}>"
      end

      def attribute_names
        self.instance_variables.collect{|var| var.gsub('@','').intern}
      end

      def ==(other)
        self.instance_variables == other.instance_variables &&
          self.instance_variables.all?{|var| self.instance_variable_get(var) == other.instance_variable_get(var)}
      end

      def eql?(other)
        self.class.eql?(other.class)
          self.instance_variables.eql?(other.instance_variables) &&
          self.instance_variables.all?{|var| self.instance_variable_get(var).eql?(other.instance_variable_get(var))}
      end
    end
  end
end
