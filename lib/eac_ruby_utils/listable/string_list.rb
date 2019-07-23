# frozen_string_literal: true

require_relative 'list'

module EacRubyUtils
  module Listable
    class StringList < ::EacRubyUtils::Listable::List
      protected

      def parse_labels(labels)
        if labels.first.is_a?(Hash)
          Hash[labels.first.map { |k, v| [k.to_s, v.to_s] }]
        else
          Hash[labels.map { |v| [v.to_s, v.to_s] }]
        end
      end
    end
  end
end
