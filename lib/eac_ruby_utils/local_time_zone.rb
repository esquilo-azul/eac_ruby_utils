# frozen_string_literal: true

require 'active_support/values/time_zone'

module EacRubyUtils
  module LocalTimeZone
    class << self
      TIMEDATECTL_TIMEZONE_LINE_PATTERN = %r{\s*Time zone:\s*(\S+/\S+)\s}.freeze

      def auto
        by_timedatectl || by_offset
      end

      def by_offset
        ::ActiveSupport::TimeZone[::Time.now.getlocal.gmt_offset].name
      end

      def by_timedatectl
        executable = ::EacRubyUtils::Envs.local.executable('timedatectl', '--version')
        return nil unless executable.exist?

        TIMEDATECTL_TIMEZONE_LINE_PATTERN.if_match(executable.command.execute!) { |m| m[1] }
      end
    end
  end
end
