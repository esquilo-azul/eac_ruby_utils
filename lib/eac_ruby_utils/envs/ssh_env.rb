module EacRubyUtils
  module Envs
    class SshEnv < ::EacRubyUtils::Envs::BaseEnv
      def initialize(user_hostname)
        @user_hostname = user_hostname
      end

      def to_s
        "SSH(#{@user_hostname})"
      end

      def command_line(line)
        "ssh #{Shellwords.escape(@user_hostname)} #{Shellwords.escape(line)}"
      end
    end
  end
end
