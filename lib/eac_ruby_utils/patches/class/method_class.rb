# frozen_string_literal: true

require 'eac_ruby_utils/acts_as_instance_method'

class Class
  # @deprecated Use {#acts_as_instance_method} instead.
  def enable_method_class
    acts_as_instance_method
  end
end
