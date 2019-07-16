# frozen_string_literal: true

module EacRubyUtils
  # Provides the method context which search and call a method in self and ancestor objects.
  module Contextualizable
    def context(method)
      current = self
      while current
        return current.send(method) if current.respond_to?(method)
        current = current.respond_to?(:parent) ? current.parent : nil
      end
      raise "Context method \"#{method}\" not found for #{self.class}"
    end
  end
end
