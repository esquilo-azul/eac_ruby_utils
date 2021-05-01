# frozen_string_literal: true

module EacRubyUtils
  class RegexpParser
    attr_reader :pattern, :builder_proc

    def initialize(pattern, &builder_proc)
      @pattern = pattern
      @builder_proc = builder_proc
    end

    def parse(string)
      internal_parse(string)[1]
    end

    def parse!(string)
      match, result = internal_parse(string)
      return result if match

      raise ::ArgumentError, "String \"#{string}\" does not match pattern \"#{pattern}\""
    end

    private

    def internal_parse(string)
      m = pattern.match(string)
      if m
        [true, builder_proc ? builder_proc.call(m) : m]
      else
        [false, nil]
      end
    end
  end
end
