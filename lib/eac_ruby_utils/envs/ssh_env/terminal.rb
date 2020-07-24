# frozen_string_literal: true

require 'active_support/concern'
require 'eac_ruby_utils/envs/ssh_env/dasho_options'
require 'eac_ruby_utils/listable'
require 'eac_ruby_utils/patches/object/if_present'

module EacRubyUtils
  module Envs
    class SshEnv < ::EacRubyUtils::Envs::BaseEnv
      module Terminal
        extend ::ActiveSupport::Concern

        included do
          include ::EacRubyUtils::Envs::SshEnv::DashoOptions
          add_nodasho_option('Terminal')
          include ::EacRubyUtils::Listable
          lists.add_string :terminal_option, :auto, :disable, :enable, :force
        end

        def ssh_command_line_terminal_args(value)
          self.class.lists.terminal_option.value_validate!(value)
          case value
          when TERMINAL_OPTION_AUTO then ENV['TERM'].present? ? %w[-t] : []
          when TERMINAL_OPTION_DISABLE then ['-T']
          when TERMINAL_OPTION_ENABLE then ['-t']
          when TERMINAL_OPTION_FORCE then ['-tt']
          else raise "Invalid conditional branch: #{value}"
          end
        end
      end
    end
  end
end
