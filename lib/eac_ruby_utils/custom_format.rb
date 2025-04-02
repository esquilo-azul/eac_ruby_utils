# frozen_string_literal: true

module EacRubyUtils
  # A formatter like [String.sprintf].
  class CustomFormat
    TYPE_PATTERN = /[a-zA-Z]/.freeze
    SEQUENCE_PATTERN = /(?<!%)%(#{TYPE_PATTERN})/.freeze

    attr_reader :mapping

    def initialize(mapping)
      @mapping = mapping.transform_keys(&:to_sym).freeze
    end

    def format(string)
      ::EacRubyUtils::CustomFormat::String.new(self, string)
    end

    class String
      attr_reader :format, :string

      def initialize(format, string)
        @format = format
        @string = string
      end

      def mapping
        @mapping ||= format.mapping.slice(*sequences)
      end

      def sequences
        @sequences ||= string.scan(SEQUENCE_PATTERN).map(&:first).uniq.map(&:to_sym)
      end

      def source_object_value(object, method)
        return object.send(method) if object.respond_to?(method)
        return object[method] if object.respond_to?('[]')

        raise ::ArgumentError, "Methods \"#{method}\" or \"[]\" not found for #{object}"
      end

      def with(source_object)
        r = string
        mapping.each do |key, method|
          r = r.gsub(/%#{::Regexp.quote(key)}/, source_object_value(source_object, method).to_s)
        end
        r.gsub('%%', '%')
      end
    end
  end
end
