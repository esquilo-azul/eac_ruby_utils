# frozen_string_literal: true

require 'yaml'

module EacRubyUtils
  class Yaml
    class << self
      def load_common(string)
        ::YAML.safe_load(string, [::Symbol, ::Date])
      end
    end
  end
end
