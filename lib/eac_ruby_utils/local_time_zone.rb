# frozen_string_literal: true

require 'active_support/core_ext/object/blank'
require 'active_support/values/time_zone'

module EacRubyUtils
  module LocalTimeZone
    DEBIAN_CONFIG_PATH = '/etc/timezone'

    class << self
      TIMEDATECTL_TIMEZONE_LINE_PATTERN = %r{\s*Time zone:\s*(\S+/\S+)\s}.freeze

      # @return [ActiveSupport::TimeZone]
      def auto
        %w[tz_env debian_config offset].lazy.map { |s| send("by_#{s}") }.find(&:present?)
      end

      def auto_set
        ::Time.zone = auto
      end

      # @return [ActiveSupport::TimeZone]
      def by_debian_config
        path = ::Pathname.new(DEBIAN_CONFIG_PATH)
        path.exist? ? path.read.strip.if_present { |v| ::ActiveSupport::TimeZone[v] } : nil
      end

      # @return [ActiveSupport::TimeZone]
      def by_offset
        ::ActiveSupport::TimeZone[::Time.now.getlocal.gmt_offset]
      end

      # @return [ActiveSupport::TimeZone]
      def by_timedatectl
        executable = ::EacRubyUtils::Envs.local.executable('timedatectl', '--version')
        return nil unless executable.exist?

        TIMEDATECTL_TIMEZONE_LINE_PATTERN.if_match(executable.command.execute!) { |m| m[1] }
                                         .if_present { |v| ::ActiveSupport::TimeZone[v] }
      end

      # @return [ActiveSupport::TimeZone]
      def by_tz_env
        ENV['TZ'].presence
      end
    end
  end
end
