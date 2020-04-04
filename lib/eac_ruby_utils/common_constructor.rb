# frozen_string_literal: true

require 'active_support/callbacks'
require 'eac_ruby_utils/arguments_consumer'
require 'ostruct'

module EacRubyUtils
  class CommonConstructor
    attr_reader :args, :options

    class << self
      def parse_args_options(args)
        result = ::OpenStruct.new(args: [], options: {})
        options_reached = false
        args.each do |arg|
          raise "Options reached and there is more arguments (Arguments: #{args})" if
          options_reached

          options_reached = parse_arg_options_process_arg(result, arg)
        end
        result
      end

      private

      def parse_arg_options_process_arg(result, arg)
        if arg.is_a?(::Hash)
          result.options = arg
          true
        else
          result.args << arg
          false
        end
      end
    end

    def initialize(*args)
      args_processed = self.class.parse_args_options(args)
      @args = args_processed.args
      @options = args_processed.options
    end

    def args_count
      (args_count_min..args_count_max)
    end

    def args_count_min
      args.count - default_values.count
    end

    def args_count_max
      args.count
    end

    def default_values
      options[:default] || []
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
        arg_index = common_constructor.args.index(arg_name)
        if arg_index < args.count
          args[arg_index]
        else
          common_constructor.default_values[arg_index - common_constructor.args_count_min]
        end
      end

      def object_attributes_set
        common_constructor.args.each do |arg_name|
          object.send("#{arg_name}=", arg_value(arg_name))
        end
      end

      def validate_args_count
        return if common_constructor.args_count.include?(args.count)

        raise ArgumentError, "#{object.class}.initialize: wrong number of arguments" \
          " (given #{args.count}, expected #{common_constructor.args_count})"
      end
    end
  end
end
