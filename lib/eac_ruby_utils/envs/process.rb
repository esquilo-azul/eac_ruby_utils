# frozen_string_literal: true

require 'open3'

module EacRubyUtils
  module Envs
    class Process
      def initialize(command)
        @data = { command: command }
        @data[:stdout], @data[:stderr], @data[:exit_code] = Open3.capture3(command)
        @data[:exit_code] = @data[:exit_code].to_i
      end

      def to_h
        @data.dup
      end
    end
  end
end
