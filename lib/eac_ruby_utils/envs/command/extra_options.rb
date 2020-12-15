# frozen_string_literal: true

require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/object/blank'
require 'shellwords'

module EacRubyUtils
  module Envs
    class Command
      module ExtraOptions
        def chdir(dir)
          duplicate_by_extra_options(chdir: dir)
        end

        def status_result(status_code, result)
          duplicate_by_extra_options(status_results: status_results.merge(status_code => result))
        end

        private

        attr_reader :extra_options

        def status_results
          extra_options[:status_results] ||= {}.with_indifferent_access
        end

        def append_chdir(command)
          extra_options[:chdir].present? ? "(cd '#{extra_options[:chdir]}' ; #{command} )" : command
        end
      end
    end
  end
end
