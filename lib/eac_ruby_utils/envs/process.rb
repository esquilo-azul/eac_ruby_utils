# frozen_string_literal: true

require 'open3'

module EacRubyUtils
  module Envs
    class Process
      def initialize(command)
        @command = command
        @stdout, @stderr, exit_code = Open3.capture3(command)
        @exit_code = exit_code.to_i
      end

      def to_h
        { exit_code: @exit_code, stdout: @stdout, stderr: @stderr, command: @command }
      end
    end
  end
end
