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

        attr_reader :block, :original_env

        def initialize(&block)
          @block = block
          @original_env = ::ENV.to_h
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

        def clean_env
          r = original_env.dup
          r.delete_if { |k, _| envvars_prefixes_to_clean.any? { |prefix| k.start_with?(prefix) } }
          r
        end

        def on_clean_envvars
          ::Bundler.send('with_env', clean_env) { block.call }
        end
      end
    end
  end
end
