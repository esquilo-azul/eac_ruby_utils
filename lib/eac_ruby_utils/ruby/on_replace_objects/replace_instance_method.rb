# frozen_string_literal: true

require 'active_support/inflector'
require 'eac_ruby_utils/ruby/on_replace_objects/replace_instance_method'

module EacRubyUtils
  module Ruby
    class OnReplaceObjects
      class ReplaceInstanceMethod
        attr_reader :a_module, :method_new_block, :original_method

        def initialize(a_module, method_name, &method_new_block)
          @a_module = a_module
          @original_method = a_module.instance_method(method_name)
          @method_new_block = method_new_block
        end

        def apply
          a_module.define_method(method_name, &method_new_block)

          self
        end

        def method_name
          original_method.name
        end

        def restore
          a_module.define_method(method_name, original_method)

          self
        end
      end
    end
  end
end
