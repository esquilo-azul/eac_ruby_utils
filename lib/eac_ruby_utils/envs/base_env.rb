# frozen_string_literal: true

require 'eac_ruby_utils/envs/command'
require 'eac_ruby_utils/envs/executable'

module EacRubyUtils
  module Envs
    class BaseEnv
      def command(*args)
        ::EacRubyUtils::Envs::Command.new(self, args)
      end

      def file_exist?(file)
        command(['stat', file]).execute[:exit_code].zero?
      end

      def executable(*executable_new_args)
        ::EacRubyUtils::Envs::Executable.new(self, *executable_new_args)
      end
    end
  end
end
