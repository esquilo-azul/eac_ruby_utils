# frozen_string_literal: true

require 'eac_ruby_utils/immutable/common_accessor'
require 'eac_ruby_utils/patches/class/common_constructor'

module EacRubyUtils
  module Immutable
    class BooleanAccessor < ::EacRubyUtils::Immutable::CommonAccessor
      def apply(klass)
        super
        accessor = self
        klass.send(:define_method, "#{name}?") { send(accessor.name) }
      end
    end
  end
end
