# frozen_string_literal: true

require 'eac_ruby_utils/module_ancestors_variable/hash'
require 'eac_ruby_utils/patches/class/self_included_modules'
require 'eac_ruby_utils/patches/module/common_concern'
require 'eac_ruby_utils/unimplemented_method_error'

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
        abstract_methods_hash[name.to_sym] = arguments
      end

      # @param methods_names [Enumerable<Object>] Each item can be a symbolizable or a hash.
      # @return [void]
      def abstract_methods(*methods_names)
        methods_names.each do |method_name|
          if method_name.is_a?(::Hash)
            abstract_methods_from_hash(method_name)
          else
            abstract_method(method_name)
          end
        end
      end

      private

      # @param hash [Hash]
      # @return [void]
      def abstract_methods_from_hash(hash)
        hash.each { |name, arguments| abstract_method(name, *arguments) }
      end

      # @return [Hash<Symbol, Array]
      def abstract_methods_hash
        @abstract_methods_hash ||=
          ::EacRubyUtils::ModuleAncestorsVariable::Hash.new(self, __method__)
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

      # @param method_name [Symbol]
      # @return [Boolean]
      def abstract_method?(method_name)
        return false if self.class.method_defined?(method_name)

        self.class.send(:abstract_methods_hash).key?(method_name.to_sym)
      end

      def raise_abstract_method(method_name, arguments = [])
        raise ::EacRubyUtils::UnimplementedMethodError,
              "Abstract method #{method_name}(#{arguments.join(', ')}) hit in " \
              "#{self}\" (Class: #{self.class})"
      end
    end
  end
end
