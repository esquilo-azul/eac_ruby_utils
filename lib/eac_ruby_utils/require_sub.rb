# frozen_string_literal: true

require 'eac_ruby_utils/require_sub/base'

module EacRubyUtils
  class << self
    def require_sub(file, options = {})
      ::EacRubyUtils::RequireSub::Base.new(file, options).apply
    end
  end
end
