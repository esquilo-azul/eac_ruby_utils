# frozen_string_literal: true

require 'bundler'

module EacRubyUtils
  module Ruby
    class << self
      # Executes a block in an environment when the variables BUNDLE* and RUBY* are removed.
      def on_clean_environment
        bundler_with_unbundled_env do
          on_clean_envvars('BUNDLE', 'RUBY') { yield }
        end
      end

      private

      def bundler_with_unbundled_env(&block)
        if ::Bundler.respond_to?(:with_unbundled_env)
          ::Bundler.with_unbundled_env(&block)
        else
          ::Bundler.with_clean_env(&block)
        end
      end

      def on_clean_envvars(*start_with_vars)
        old_values = envvars_starting_with(start_with_vars)
        old_values.each_key { |k| ENV.delete(k) }
        yield
      ensure
        old_values&.each { |k, v| ENV[k] = v }
      end

      def envvars_starting_with(start_with_vars)
        ENV.select { |k, _v| start_with_vars.any? { |var| k.start_with?(var) } }
      end
    end
  end
end
