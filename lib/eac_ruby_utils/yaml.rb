# frozen_string_literal: true

require 'yaml'

module EacRubyUtils
  # A safe YAML loader/dumper with common types included.
  class Yaml
    class << self
      DEFAULT_PERMITTED_CLASSES = [::Array, ::Date, ::FalseClass, ::Hash, ::NilClass, ::Numeric,
                                   ::String, ::Symbol, ::Time, ::TrueClass].freeze

      def load(string)
        ::YAML.safe_load(string, permitted_classes)
      end

      def permitted_classes
        DEFAULT_PERMITTED_CLASSES
      end

      def sanitize(object)
        Sanitizer.new(object).result
      end

      class Sanitizer
        attr_reader :source

        RESULT_TYPES = %w[permitted enumerableable hashable].freeze

        def initialize(source)
          @source = source
        end

        def result
          RESULT_TYPES.each do |type|
            return send("result_#{type}") if send("result_#{type}?")
          end

          source.to_s
        end

        private

        def result_enumerableable?
          source.respond_to?(:to_a) && !source.is_a?(::Hash)
        end

        def result_enumerableable
          source.to_a.map { |child| sanitize_value(child) }
        end

        def result_hashable?
          source.respond_to?(:to_h)
        end

        def result_hashable
          source.to_h.map { |k, v| [k.to_sym, sanitize_value(v)] }.to_h
        end

        def result_nil?
          source.nil?
        end

        def result_nil
          nil
        end

        def result_permitted?
          (::EacRubyUtils::Yaml.permitted_classes - [::Array, ::Hash])
            .any? { |klass| source.is_a?(klass) }
        end

        def result_permitted
          source
        end

        def sanitize_value(value)
          self.class.new(value).result
        end
      end
    end
  end
end
