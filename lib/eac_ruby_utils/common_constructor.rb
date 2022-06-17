# frozen_string_literal: true

require 'active_support/callbacks'
require 'eac_ruby_utils/arguments_consumer'
require 'eac_ruby_utils/common_constructor/class_initialize'
require 'ostruct'

module EacRubyUtils
  class CommonConstructor
    attr_reader :args, :options, :after_set_block

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

    def initialize(*args, &after_set_block)
      args_processed = self.class.parse_args_options(args)
      @args = args_processed.args
      @options = args_processed.options
      @after_set_block = after_set_block
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

      klass
    end

    def setup_class_attr_readers(klass)
      klass.send(:attr_reader, *args)
      klass.send(:public, *args) if args.any?
    end

    def setup_class_attr_writers(klass)
      klass.send(:attr_writer, *args)
      klass.send(:private, *args.map { |a| "#{a}=" }) if args.any?
    end

    def setup_class_initialize(klass)
      klass.include(::ActiveSupport::Callbacks)
      klass.define_callbacks :initialize
      ::EacRubyUtils::CommonConstructor::ClassInitialize.new(self, klass).run
    end

    def super_args
      options[:super_args]
    end
  end
end
