# frozen_string_literal: true

require 'eac_ruby_utils/require_sub'

class Module
  def require_sub(file_path)
    ::EacRubyUtils.require_sub(file_path)
  end
end
