# frozen_string_literal: true

require 'eac_ruby_utils/patches/class/self_included_modules'
require 'eac_ruby_utils/patches/module/common_concern'

module EacRubyUtils
  # Support to abstract methods.
  #
  # Usage:
  #
  #   require 'eac_ruby_utils/acts_as_abstract'
  #
  #   class BaseClass
  #     include EacRubyUtils::ActsAsAbstract
  #
  #     abstract_methods :mymethod
  #   end
  #
  #   BaseClass.new.mymethod # raise "Abstract method: mymethod"
  #
  #   class SubClass
  #     def mymethod
  #       "Implemented"
  #     end
  #   end
  #
  #   SubClass.new.mymethod # return "Implemented"
  module ActsAsAbstract
    common_concern

    class << self
      def abstract?(a_class)
        a_class.self_included_modules.include?(::EacRubyUtils::ActsAsAbstract)
      end
    end

    module ClassMethods
      # @param name [Symbol]
      # @param arguments [Enumerable<Symbol>]
      # @return [void]
      def abstract_method(name, *arguments)
        define_method name.to_sym do |*_the_args|
          raise_abstract_method(name.to_sym, arguments)
        end
      end

      def abstract_methods(*methods_names)
        methods_names.each do |method_name|
          abstract_method(method_name)
        end
      end
    end

    module InstanceMethods
      def respond_to_missing?(method_name, include_private = false)
        super || abstract_method?(method_name)
      end

      def method_missing(method_name, *arguments, &block)
        raise_abstract_method(method_name) if abstract_method?(method_name)

        super
      end

      def abstract_method?(method_name)
        self.class.abstract_methods.include?(method_name.to_sym)
      end

      def raise_abstract_method(method_name, arguments = [])
        raise ::NoMethodError, "Abstract method #{method_name}(#{arguments.join(', ')}) hit in " \
          "#{self}\" (Class: #{self.class})"
      end
    end
  end
end
