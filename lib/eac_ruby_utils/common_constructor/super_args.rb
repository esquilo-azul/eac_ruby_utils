# frozen_string_literal: true

module EacRubyUtils
  class CommonConstructor
    class SuperArgs
      attr_reader :common_constructor, :args, :object

      def initialize(common_constructor, args, object)
        @common_constructor = common_constructor
        @args = args
        @object = object
      end

      def auto_result
        r = []
        sub_args.each do |name, value|
          i = super_arg_index(name)
          r[i] = value if i
        end
        r
      end

      def result
        result_from_options || auto_result
      end

      def result_from_options
        return unless common_constructor.super_args

        object.instance_exec(&common_constructor.super_args)
      end

      def sub_args
        common_constructor.args.each_with_index.map do |name, index|
          [name, args[index]]
        end.to_h
      end

      def super_arg_index(name)
        super_method.parameters.each_with_index do |arg, index|
          return index if arg[1] == name
        end
        nil
      end

      def super_method
        object.class.superclass ? object.class.superclass.instance_method(:initialize) : nil
      end
    end
  end
end
