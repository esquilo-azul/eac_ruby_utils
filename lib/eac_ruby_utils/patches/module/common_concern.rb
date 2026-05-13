# frozen_string_literal: true

require 'eac_ruby_utils/common_concern'

class Module
  def common_concern(&)
    ::EacRubyUtils::CommonConcern.new(&).setup(self)
  end
end
