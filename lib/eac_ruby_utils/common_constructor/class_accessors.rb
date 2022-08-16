# frozen_string_literal: true

require 'eac_ruby_utils/common_constructor/instance_initialize'
require 'eac_ruby_utils/common_constructor/super_args'

module EacRubyUtils
  class CommonConstructor
    class ClassAccessors
      attr_reader :common_constructor, :klass

      def initialize(common_constructor, klass)
        @common_constructor = common_constructor
        @klass = klass
      end

      def args
        common_constructor.all_args
      end

      def perform
        setup_class_attr_readers
        setup_class_attr_writers
      end

      def setup_class_attr_readers
        klass.send(:attr_reader, *args)
        klass.send(:public, *args) if args.any?
      end

      def setup_class_attr_writers
        klass.send(:attr_writer, *args)
        klass.send(:private, *args.map { |a| "#{a}=" }) if args.any?
      end
    end
  end
end
