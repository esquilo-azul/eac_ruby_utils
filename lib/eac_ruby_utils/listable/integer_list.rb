# frozen_string_literal: true

require_relative 'list'

module EacRubyUtils
  module Listable
    class IntegerList < ::EacRubyUtils::Listable::List
      protected

      def parse_labels(labels)
        if labels.first.is_a?(Hash)
          Hash[labels.first.map { |k, v| [k.to_i, v.to_s] }]
        else
          Hash[labels.each_with_index.map { |v, i| [i + 1, v.to_s] }]
        end
      end

      def build_value(index, _key)
        index + 1
      end
    end
  end
end
