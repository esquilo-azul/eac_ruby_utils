# frozen_string_literal: true

require 'eac_ruby_utils/patches/time/local_time_zone'

::Time.zone = ::Time.local_time_zone
