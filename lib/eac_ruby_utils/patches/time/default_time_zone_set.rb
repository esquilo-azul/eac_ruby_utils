# frozen_string_literal: true

require 'active_support/core_ext/time/zones'
require 'eac_ruby_utils/patches/time/local_time_zone'

::Time.zone = ::Time.local_time_zone
