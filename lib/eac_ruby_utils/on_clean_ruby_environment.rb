# frozen_string_literal: true

require 'eac_ruby_utils/ruby/on_clean_environment'

module EacRubyUtils
  class << self
    # <b>DEPRECATED:</b> Please use <tt>EacRubyUtils::Ruby.on_clean_environment</tt> instead.
    def on_clean_ruby_environment(*args, &block)
      ::EacRubyUtils::Ruby.on_clean_environment(*args, &block)
    end
  end
end
