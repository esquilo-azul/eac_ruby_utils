module EacRubyUtils
  module Envs
    class Process
      def initialize(command)
        @command = command
        Open3.popen3(command) do |_stdin, stdout, stderr, wait_thr|
          @exit_code = wait_thr.value.to_i
          @stdout = stdout.read
          @stderr = stderr.read
        end
      end

      def to_h
        { exit_code: @exit_code, stdout: @stdout, stderr: @stderr, command: @command }
      end
    end
  end
end
