# frozen_string_literal: true

require 'eac_ruby_utils/common_concern'

class Module
  def common_concern(&after_callback)
    ::EacRubyUtils::CommonConcern.new(&after_callback).setup(self)
  end
end
