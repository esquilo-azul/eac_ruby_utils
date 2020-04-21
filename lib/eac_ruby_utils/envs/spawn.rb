# frozen_string_literal: true

module EacRubyUtils
  module Envs
    class Spawn
      attr_reader :command, :pid

      def initialize(command)
        @command = command
        @pid = ::Process.spawn(command)
      end

      def kill(signal)
        ::Process.kill(signal, pid)
      end

      def kill_at_end(&block)
        block.call(self)
      ensure
        kill('KILL')
      end

      def to_h
        { command: command, pid: pid }
      end

      def wait
        ::Process.wait pid
      end
    end
  end
end
