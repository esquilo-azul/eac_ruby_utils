# frozen_string_literal: true

module EacRubyUtils
  module Rspec
    module Setup
      module Conditionals
        def conditional(tag, &condition)
          message = condition.call
          return if message.blank?

          puts("[WARN] Excluded tag: #{tag}: #{message}")
          rspec_config.filter_run_excluding tag
        end
      end
    end
  end
end
