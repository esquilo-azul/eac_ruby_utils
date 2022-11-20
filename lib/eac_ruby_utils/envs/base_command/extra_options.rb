# frozen_string_literal: true

require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/object/blank'
require 'shellwords'

module EacRubyUtils
  module Envs
    module BaseCommand
      module ExtraOptions
        # @return [ActiveSupport::HashWithIndifferentAccess]
        def extra_options
          @extra_options ||= {}.with_indifferent_access
        end

        def status_result(status_code, result)
          duplicate_by_extra_options(status_results: status_results.merge(status_code => result))
        end

        private

        def status_results
          extra_options[:status_results] ||= {}.with_indifferent_access
        end
      end
    end
  end
end
