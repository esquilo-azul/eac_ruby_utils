# frozen_string_literal: true

require 'active_support/hash_with_indifferent_access'
require 'ostruct'

module EacRubyUtils
  class ArgumentsConsumer
    class << self
      def parse(args, positional = [], options = {})
        new(args, positional, options).data
      end
    end

    attr_reader :positional, :default_options

    def initialize(positional, default_options)
      @positional = positional.dup.freeze
      @default_options = default_options.dup.freeze
    end

    def parse(args)
      Parser.new(self, args).data
    end

    def initialize2(args, positional, _default_options)
      @positional = positional.dup
      @positional.freeze
      @args = args

      @options_found = false
    end

    class Parser
      attr_reader :data, :arguments_consumer

      def initialize(arguments_consumer, args)
        @arguments_consumer = arguments_consumer
        @data = ::ActiveSupport::HashWithIndifferentAccess.new
        @options_found = false
        arguments_consumer.positional.each { |key| data[key] = nil }
        data.merge!(arguments_consumer.default_options)
        args.each_with_index { |value, index| add_arg(value, index) }
        data.freeze
      end

      private

      def add_arg(value, index)
        arg = ::OpenStruct.new(value: value, index: index)
        if arg.value.is_a?(::Hash)
          add_hash_arg(arg)
        else
          add_positional_arg(arg)
        end
      end

      def add_hash_arg(arg)
        check_no_more_arguments(arg)
        data.merge!(arg.value)
        @options_found = true
      end

      def add_positional_arg(arg)
        check_no_more_arguments(arg)
        invalid_argument arg, 'No more valid positional' if
          arg.index >= arguments_consumer.positional.count
        data[arguments_consumer.positional[arg.index]] = arg.value
      end

      def check_no_more_arguments(arg)
        return unless @options_found

        invalid_argument arg, 'Hash already found - no more positional allowed'
      end

      def invalid_argument(arg, message)
        raise InvalidArgumentError.new(self, arg, message)
      end
    end

    class InvalidArgumentError < StandardError
      def initialize(args_consumer, arg, message)
        @args_consumer = args_consumer
        @arg = arg
        super "#{message} (Arg: #{arg}, Args Consumer: #{args_consumer})"
      end
    end
  end
end
