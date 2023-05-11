# frozen_string_literal: true

require 'eac_ruby_utils/patches/module/acts_as_abstract'

class Module
  # @deprecated Use {#acts_as_abstract} instead.
  def enable_abstract_methods(*methods)
    acts_as_abstract(*methods)
  end
end
