# frozen_string_literal: true

require 'addressable'
require 'eac_ruby_utils/envs/base_env'
require 'net/ssh'
require 'shellwords'

module EacRubyUtils
  module Envs
    class SshEnv < ::EacRubyUtils::Envs::BaseEnv
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
        @uri = self.class.parse_uri(uri).freeze
      end

      def to_s
        uri.to_s
      end

      def command_line(line)
        "#{ssh_command_line} #{Shellwords.escape(line)}"
      end

      private

      def ssh_command_line
        r = %w[ssh]
        r += ['-p', uri.port] if uri.port.present?
        r += ssh_command_line_options
        r << user_hostname_uri
        r.map { |a| Shellwords.escape(a) }.join(' ')
      end

      def ssh_command_line_options
        r = []
        uri.query_values&.each { |k, v| r += ['-o', "#{k}=#{v}"] }
        r
      end

      def user_hostname_uri
        r = uri.host
        r = "#{uri.user}@#{r}" if uri.user.present?
        r
      end
    end
  end
end
