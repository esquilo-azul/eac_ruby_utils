# frozen_string_literal: true

class Class
  def self_included_modules
    ancestors.take_while { |a| a != superclass }.select { |ancestor| ancestor.instance_of?(Module) }
  end
end
