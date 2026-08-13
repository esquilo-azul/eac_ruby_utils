# frozen_string_literal: true

require 'eac_ruby_utils/patches/module/common_concern'

module EacRubyUtils
  class << self
    def patch_module(*)
      ::EacRubyUtils::PatchModule.perform(*)
    end
  end

  module PatchModule
    class << self
      def perform(target, patch)
        return if target.include?(patch)

        target.send(:include, patch)
      end
    end
  end
end
