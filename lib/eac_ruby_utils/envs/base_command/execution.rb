# frozen_string_literal: true

require 'eac_ruby_utils/envs/execution_error'
require 'eac_ruby_utils/envs/execution_result'
require 'eac_ruby_utils/envs/process'
require 'eac_ruby_utils/envs/spawn'
require 'pp'

module EacRubyUtils
  module Envs
    module BaseCommand
      module Execution
        def execute!(options = {})
          options[:exit_outputs] = status_results.merge(options[:exit_outputs].presence || {})
          er = ::EacRubyUtils::Envs::ExecutionResult.new(execute(options), options)
          return er.result if er.success?

          raise ::EacRubyUtils::Envs::ExecutionError,
                "execute! command failed: #{self}\n#{er.r.pretty_inspect}"
        end

        def execute(options = {})
          c = command(options)
          debug_print("BEFORE: #{c}")
          t1 = Time.now
          r = ::EacRubyUtils::Envs::Process.new(c).to_h
          i = Time.now - t1
          debug_print("AFTER [#{i}]: #{c}")
          r
        end

        def spawn(options = {})
          c = command(options)
          debug_print("SPAWN: #{c}")
          ::EacRubyUtils::Envs::Spawn.new(c)
        end

        def system!(options = {})
          return if system(options)

          raise ::EacRubyUtils::Envs::ExecutionError, "system! command failed: #{self}"
        end

        def system(options = {})
          c = command(options)
          debug_print(c)
          Kernel.system(c)
        end
      end
    end
  end
end
