# frozen_string_literal: true

module EacRubyUtils
  class Boolean
    class << self
      def parse(value)
        return parse_string(value) if value.is_a?(::String)
        return parse_string(value.to_s) if value.is_a?(::Symbol)
        return parse_number(value) if value.is_a?(::Numeric)

        value ? true : false
      end

      private

      def parse_string(value)
        ['', 'n', 'no', 'f', 'false'].include?(value.strip.downcase) ? false : true
      end

      def parse_number(value)
        value.zero?
      end
    end

    attr_reader :value

    def initialize(value)
      @value = self.class.parse(value)
    end
  end
end
