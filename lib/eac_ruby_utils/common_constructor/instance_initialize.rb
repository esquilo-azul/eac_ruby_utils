# frozen_string_literal: true

module EacRubyUtils
  class CommonConstructor
    class InstanceInitialize
      attr_reader :common_constructor, :args, :object, :block

      def initialize(common_constructor, args, object, block)
        @common_constructor = common_constructor
        @args = args
        @object = object
        @block = block
      end

      def perform
        validate_args_count
        object.run_callbacks :initialize do
          object_attributes_set
          object_block_set
          object_after_callback
        end
      end

      private

      def arg_value(arg_name)
        arg_index = common_constructor.args.index(arg_name)
        if arg_index < args.count
          args[arg_index]
        else
          common_constructor.default_values[arg_index - common_constructor.args_count_min]
        end
      end

      def object_after_callback
        return unless common_constructor.after_set_block

        object.instance_eval(&common_constructor.after_set_block)
      end

      def object_attribute_set(attr_name, attr_value)
        object.send("#{attr_name}=", attr_value)
      end

      def object_attributes_set
        common_constructor.args.each do |arg_name|
          object_attribute_set(arg_name, arg_value(arg_name))
        end
      end

      def object_block_set
        block_arg = common_constructor.block_arg
        object_attribute_set(block_arg, block) if block_arg
      end

      def validate_args_count
        return if common_constructor.args_count.include?(args.count)

        raise ArgumentError, "#{object.class}.initialize: wrong number of arguments" \
          " (given #{args.count}, expected #{common_constructor.args_count})"
      end
    end
  end
end
