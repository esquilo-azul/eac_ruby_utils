# frozen_string_literal: true

require 'active_support/core_ext/object/blank'
require 'eac_ruby_utils/envs/ssh_env'
require 'eac_ruby_utils/patches/object/if_present'

module EacRubyUtils
  module Rspec
    class StubbedSsh
      DEFAULT_ENVVAR_NAME = 'STUBBED_SSH_URL'

      class << self
        def default
          @default ||= new(DEFAULT_ENVVAR_NAME)
        end
      end

      attr_reader :envvar_name

      def initialize(envvar_name)
        @envvar_name = envvar_name
      end

      def validate
        return nil if provided_url.present?

        "Environment variable \"#{envvar_name}\" unprovided or blank"
      end

      def validate!
        validate.if_present { |v| raise v }
      end

      def provided_url
        ENV[envvar_name]
      end

      def build_env
        validate!
        ::EacRubyUtils::Envs::SshEnv.new(provided_url)
      end
    end
  end
end
