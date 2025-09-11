# frozen_string_literal: true

require 'eac_ruby_utils/patches/module/common_concern'
require 'eac_ruby_utils/require_sub'

module EacRubyUtils
  module ActsAsImmutable
    ::EacRubyUtils.require_sub __FILE__

    common_concern do
      include ::EacRubyUtils::Listable

      lists.add_symbol :type, :array, :boolean, :common, :hash
    end
  end
end
