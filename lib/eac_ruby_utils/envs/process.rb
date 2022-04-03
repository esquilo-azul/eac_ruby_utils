# frozen_string_literal: true

require 'open3'

module EacRubyUtils
  module Envs
    class Process
      EXIT_CODE_KEY = :exit_code
      ERR_KEY = :stderr
      OUT_KEY = :stdout

      def initialize(command)
        self.data = { command: command }
        data[OUT_KEY], data[ERR_KEY], data[EXIT_CODE_KEY] = Open3.capture3(command)
        data[EXIT_CODE_KEY] = data[EXIT_CODE_KEY].to_i
      end

      def to_h
        data.dup
      end

      private

      attr_accessor :data
    end
  end
end
