# frozen_string_literal: true

require 'eac_ruby_utils/common_constructor'

class Class
  def common_constructor(*args)
    ::EacRubyUtils::CommonConstructor.new(*args).setup_class(self)
  end
end
