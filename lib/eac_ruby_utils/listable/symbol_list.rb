# frozen_string_literal: true

require_relative 'list'

module EacRubyUtils
  module Listable
    class SymbolList < ::EacRubyUtils::Listable::List
      protected

      def parse_labels(labels)
        if labels.first.is_a?(Hash)
          Hash[labels.first.map { |k, v| [k.to_sym, v.to_sym] }]
        else
          Hash[labels.map { |v| [v.to_sym, v.to_sym] }]
        end
      end
    end
  end
end
