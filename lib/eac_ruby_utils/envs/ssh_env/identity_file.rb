# frozen_string_literal: true

require 'active_support/concern'
require 'eac_ruby_utils/envs/ssh_env/dasho_options'
require 'eac_ruby_utils/listable'
require 'eac_ruby_utils/patches/object/if_present'

module EacRubyUtils
  module Envs
    class SshEnv < ::EacRubyUtils::Envs::BaseEnv
      module IdentityFile
        extend ::ActiveSupport::Concern

        included do
          include ::EacRubyUtils::Envs::SshEnv::DashoOptions

          add_nodasho_option('IdentityFile')
        end

        def ssh_command_line_identity_file_args(value)
          ['-i', value]
        end
      end
    end
  end
end
