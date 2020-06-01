# frozen_string_literal: true

require 'yaml'

module EacRubyUtils
  # A safe YAML loader/dumper with common types included.
  class Yaml
    class << self
      DEFAULT_PERMITTED_CLASSES = [::Symbol, ::Date].freeze

      def load(string)
        ::YAML.safe_load(string, permitted_classes)
      end

      def permitted_classes
        DEFAULT_PERMITTED_CLASSES
      end
    end
  end
end
