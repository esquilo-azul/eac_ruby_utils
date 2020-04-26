# frozen_string_literal: true

require 'eac_ruby_utils/common_constructor'

class Class
  def common_constructor(*args, &block)
    ::EacRubyUtils::CommonConstructor.new(*args, &block).setup_class(self)
  end
end
