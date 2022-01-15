# frozen_string_literal: true

module EacRubyUtils
  class Context
    delegate :any?, to: :stack

    def current
      optional_current || raise('No elements in context')
    end

    def optional_current
      stack.last
    end

    delegate :pop, to: :stack
    delegate :push, to: :stack

    def on(obj)
      push(obj)
      begin
        yield
      ensure
        pop
      end
    end

    private

    def stack
      @stack ||= []
    end
  end
end
