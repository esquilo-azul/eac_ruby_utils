# frozen_string_literal: true

require 'eac_ruby_utils/patches/module/common_concern'

module EacRubyUtils
  # Support to abstract methods.
  #
  # Usage:
  #
  #   require 'eac_ruby_utils/abstract_methods'
  #
  #   class BaseClass
  #     include EacRubyUtils::AbstractMethods
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
  module AbstractMethods
    common_concern

    module ClassMethods
      def abstract_methods(*methods_names)
        @abstract_methods ||= Set.new
        @abstract_methods += methods_names.map(&:to_sym)

        @abstract_methods.to_enum
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

      def raise_abstract_method(method_name)
        raise ::NoMethodError, "Abstract method \"#{method_name}\" hit in \"#{self}\""
      end
    end
  end
end
