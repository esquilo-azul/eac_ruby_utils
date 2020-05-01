# frozen_string_literal: true

require 'active_support/core_ext/time/zones'
require 'eac_ruby_utils/envs'

class Time
  class << self
    TIMEDATECTL_TIMEZONE_LINE_PATTERN = %r{\s*Time zone:\s*(\S+/\S+)\s}.freeze

    def local_time_zone
      local_time_zone_by_timedatectl || local_time_zone_by_offset
    end

    def local_time_zone_by_timedatectl
      executable = ::EacRubyUtils::Envs.local.executable('timedatectl', '--version')
      return nil unless executable.exist?

      TIMEDATECTL_TIMEZONE_LINE_PATTERN.if_match(executable.command.execute!) { |m| m[1] }
    end

    def local_time_zone_by_offset
      ::ActiveSupport::TimeZone[::Time.now.getlocal.gmt_offset].name
    end
  end
end
