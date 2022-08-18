# frozen_string_literal: true

require 'bundler'

module EacRubyUtils
  module Ruby
    class << self
      # Executes a block in an environment when the variables BUNDLE* and RUBY* are removed.
      def on_clean_environment(&block)
        OnCleanEnvironment.new(&block).perform
      end

      class OnCleanEnvironment
        ENVVARS_PREFIXES_TO_CLEAN = %w[BUNDLE RUBY].freeze

        attr_reader :block

        def initialize(&block)
          @block = block
        end

        # @return [Array<String>]
        def envvars_prefixes_to_clean
          ENVVARS_PREFIXES_TO_CLEAN
        end

        def perform
          bundler_with_unbundled_env do
            on_clean_envvars
          end
        end

        private

        def bundler_with_unbundled_env(&block)
          ::Bundler.send(bundler_with_env_method_name, &block)
        end

        def bundler_with_env_method_name
          if ::Bundler.respond_to?(:with_unbundled_env)
            :with_unbundled_env
          else
            :with_clean_env
          end
        end

        def on_clean_envvars
          old_values = envvars_starting_with
          old_values.each_key { |k| ENV.delete(k) }
          block.call
        ensure
          old_values&.each { |k, v| ENV[k] = v }
        end

        def envvars_starting_with
          ENV.select { |k, _v| envvars_prefixes_to_clean.any? { |var| k.start_with?(var) } }
        end
      end
    end
  end
end
