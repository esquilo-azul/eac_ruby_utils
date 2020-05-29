# frozen_string_literal: true

require 'eac_ruby_utils/common_concern'
require 'eac_ruby_utils/console/speaker'

class Module
  def common_concern(&after_callback)
    ::EacRubyUtils::CommonConcern.new(&after_callback).setup(self)
  end
end
