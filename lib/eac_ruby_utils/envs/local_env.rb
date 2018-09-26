# frozen_string_literal: true

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
