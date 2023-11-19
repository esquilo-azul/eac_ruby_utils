# frozen_string_literal: true

require 'addressable'
require 'eac_ruby_utils/envs/base_env'
require 'eac_ruby_utils/patches/object/if_present'
require 'eac_ruby_utils/patches/module/require_sub'
require 'net/ssh'
require 'shellwords'

module EacRubyUtils
  module Envs
    class SshEnv < ::EacRubyUtils::Envs::BaseEnv
      require_sub __FILE__, include_modules: true

      USER_PATTERN = /[a-z_][a-z0-9_-]*/.freeze
      HOSTNAME_PATTERN = /[^@]+/.freeze
      USER_HOSTNAME_PATTERN = /\A(?:(#{USER_PATTERN})@)?(#{HOSTNAME_PATTERN})\z/.freeze

      class << self
        def parse_uri(uri)
          uri_by_url(uri) || uri_by_user_hostname(uri) || raise("URI has no SSH scheme: #{uri}")
        end

        private

        def uri_by_url(url)
          r = ::Addressable::URI.parse(url)
          r.scheme == 'ssh' && r.host.present? ? r : nil
        end

        def uri_by_user_hostname(user_hostname)
          m = USER_HOSTNAME_PATTERN.match(user_hostname)
          m ? ::Addressable::URI.new(scheme: 'ssh', host: m[2], user: m[1]) : nil
        rescue Addressable::URI::InvalidURIError
          nil
        end
      end

      attr_reader :uri

      def initialize(uri)
        super()
        @uri = self.class.parse_uri(uri).freeze
      end

      delegate :to_s, to: :uri

      def command_line(line)
        "#{ssh_command_line} #{Shellwords.escape(line)}"
      end

      private

      def ssh_command_line
        (%w[ssh] +
          %w[nodasho dasho port].flat_map { |m| send("ssh_command_line_#{m}_args") } +
          [user_hostname_uri])
          .map { |a| Shellwords.escape(a) }.join(' ')
      end

      def ssh_command_line_port_args
        uri.port.if_present([]) do |v|
          ['-p', v]
        end
      end

      def user_hostname_uri
        r = uri.host
        r = "#{uri.user}@#{r}" if uri.user.present?
        r
      end
    end
  end
end
