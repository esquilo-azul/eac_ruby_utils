# frozen_string_literal: true

require_relative 'list'

module EacRubyUtils
  module Listable
    class StringList < ::EacRubyUtils::Listable::List
      protected

      def parse_labels(labels)
        if labels.first.is_a?(Hash)
          labels.first.to_h { |k, v| [k.to_s, v.to_s] }
        else
          labels.to_h { |v| [v.to_s, v.to_s] }
        end
      end
    end
  end
end
