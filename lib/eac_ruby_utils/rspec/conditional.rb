# frozen_string_literal: true

require 'active_support/core_ext/object/blank'
require 'eac_ruby_utils/console/speaker'

module EacRubyUtils
  module Rspec
    class Conditional
      include ::EacRubyUtils::Console::Speaker

      def self.default
        @default ||= new
      end

      def initialize
        @tags = {}
      end

      def add(tag, &condition)
        tags[tag] = condition
      end

      def configure(rspec_config)
        tags.each do |tag, condition|
          message = condition.call
          if message.present?
            warn("Excluded tag: #{tag}: #{message}")
            rspec_config.filter_run_excluding tag
          end
        end
      end

      private

      attr_reader :tags
    end
  end
end
