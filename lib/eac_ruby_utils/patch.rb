# frozen_string_literal: true

module EacRubyUtils
  class << self
    def patch(target, patch)
      return if target.included_modules.include?(patch)

      target.send(:include, patch)
    end
  end
end
