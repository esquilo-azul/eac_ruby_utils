# frozen_string_literal: true

require 'yaml'

module EacRubyUtils
  class Yaml
    class << self
      def load(string)
        ::YAML.safe_load(string, [::Symbol, ::Date])
      end
    end
  end
end
