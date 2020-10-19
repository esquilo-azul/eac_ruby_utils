# frozen_string_literal: true

require 'active_support/core_ext/object/blank'
require 'singleton'

module EacRubyUtils
  # A blank string which returns +false+ for +blank?+ method.
  class BlankNotBlank < String
    include ::Singleton

    def initialize
      super('')
    end

    def blank?
      false
    end
  end
end
