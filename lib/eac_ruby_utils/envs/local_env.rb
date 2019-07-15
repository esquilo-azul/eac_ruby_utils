# frozen_string_literal: true

require 'eac_ruby_utils/envs/base_env'

module EacRubyUtils
  module Envs
    class LocalEnv < ::EacRubyUtils::Envs::BaseEnv
      def to_s
        'LOCAL'
      end

      def command_line(line)
        line
      end
    end
  end
end
