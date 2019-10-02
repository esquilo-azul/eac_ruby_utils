# frozen_string_literal: true

require 'eac_ruby_utils/envs/base_env'
require 'eac_ruby_utils/envs/command'
require 'eac_ruby_utils/envs/file'
require 'eac_ruby_utils/envs/local_env'
require 'eac_ruby_utils/envs/process'
require 'eac_ruby_utils/envs/ssh_env'
require 'eac_ruby_utils/envs/executable'

module EacRubyUtils
  module Envs
    class << self
      def local
        @local ||= ::EacRubyUtils::Envs::LocalEnv.new
      end

      def ssh(user_hostname)
        ::EacRubyUtils::Envs::SshEnv.new(user_hostname)
      end
    end
  end
end
