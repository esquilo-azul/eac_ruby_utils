# frozen_string_literal: true

require 'yaml'

module EacRubyUtils
  # A safe YAML loader/dumper with common types included.
  class Yaml
    class << self
      def load(string)
        ::YAML.safe_load(string, [::Symbol, ::Date])
      end
    end
  end
end
