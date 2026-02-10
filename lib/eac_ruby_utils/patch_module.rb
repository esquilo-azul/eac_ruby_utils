# frozen_string_literal: true

require 'eac_ruby_utils/patches/module/common_concern'

module EacRubyUtils
  module PatchModule
    common_concern

    class_methods do
      delegate :patch_module, to: :'::EacRubyUtils::PatchModule'
    end

    class << self
      def patch_module(target, patch)
        return if target.include?(patch)

        target.send(:include, patch)
      end
    end
  end
end
