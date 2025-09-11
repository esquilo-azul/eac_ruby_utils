# frozen_string_literal: true

require 'active_support/concern'
require 'eac_ruby_utils/boolean'
require 'eac_ruby_utils/envs/ssh_env/dasho_options'

module EacRubyUtils
  module Envs
    class SshEnv < ::EacRubyUtils::Envs::BaseEnv
      module Quiet
        extend ::ActiveSupport::Concern

        included do
          include ::EacRubyUtils::Envs::SshEnv::DashoOptions

          add_nodasho_option('Quiet')
        end

        def ssh_command_line_quiet_args(value)
          ::EacRubyUtils::Boolean.parse(value) ? ['-q'] : []
        end
      end
    end
  end
end
