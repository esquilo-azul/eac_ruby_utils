# frozen_string_literal: true

require 'active_support/callbacks'

module EacRubyUtils
  class CommonConstructor
    attr_reader :args, :options

    def initialize(*args)
      @args = args
    end

    def setup_class(klass)
      setup_class_attr_readers(klass)
      setup_class_attr_writers(klass)
      setup_class_initialize(klass)
    end

    def setup_class_attr_readers(klass)
      klass.send(:attr_reader, *args)
      klass.send(:public, *args)
    end

    def setup_class_attr_writers(klass)
      klass.send(:attr_writer, *args)
      klass.send(:private, *args.map { |a| "#{a}=" })
    end

    def setup_class_initialize(klass)
      common_constructor = self
      klass.include(::ActiveSupport::Callbacks)
      klass.define_callbacks :initialize
      klass.send(:define_method, :initialize) do |*args|
        Initialize.new(common_constructor, args, self).run
      end
    end

    class Initialize
      attr_reader :common_constructor, :args, :object

      def initialize(common_constructor, args, object)
        @common_constructor = common_constructor
        @args = args
        @object = object
      end

      def run
        validate_args_count
        object.run_callbacks :initialize do
          object_attributes_set
        end
      end

      private

      def arg_value(arg_name)
        args[common_constructor.args.index(arg_name)]
      end

      def object_attributes_set
        common_constructor.args.each do |arg_name|
          object.send("#{arg_name}=", arg_value(arg_name))
        end
      end

      def validate_args_count
        return if args.count == common_constructor.args.count

        raise ArgumentError, "#{object.class}.initialize: wrong number of arguments" \
          " (given #{args.count}, expected #{common_constructor.args.count})"
      end
    end
  end
end
