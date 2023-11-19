# frozen_string_literal: true

require 'active_support/callbacks'
require 'eac_ruby_utils/arguments_consumer'
require 'eac_ruby_utils/common_constructor/class_accessors'
require 'eac_ruby_utils/common_constructor/class_initialize'

module EacRubyUtils
  class CommonConstructor
    attr_reader :all_args, :options, :after_set_block

    class << self
      def parse_args_options(args)
        result = ::Struct.new(:args, :options).new([], {})
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
      @all_args = args_processed.args
      @options = args_processed.options
      @after_set_block = after_set_block
    end

    def args
      block_arg? ? all_args[0..-2] : all_args
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

    def block_arg
      block_arg? ? all_args.last : nil
    end

    def block_arg?
      options[:block_arg] || false
    end

    def default_values
      options[:default] || []
    end

    def setup_class(klass)
      setup_class_accessors(klass)

      setup_class_initialize(klass)

      klass
    end

    def setup_class_accessors(klass)
      ::EacRubyUtils::CommonConstructor::ClassAccessors.new(self, klass).perform
    end

    def setup_class_initialize(klass)
      ::EacRubyUtils::CommonConstructor::ClassInitialize.new(self, klass).perform
    end

    def super_args
      options[:super_args]
    end
  end
end
