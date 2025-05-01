# frozen_string_literal: true

require 'eac_ruby_utils/patches/module/common_concern'

module EacRubyUtils
  module PatchModule
    common_concern

    class_methods do
      def patch_module(target, patch)
        return if target.included_modules.include?(patch)

        target.send(:include, patch)
      end
    end
  end
end
