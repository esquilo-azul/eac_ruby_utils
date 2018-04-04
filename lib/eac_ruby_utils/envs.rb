module EacRubyUtils
  module Envs
    class << self
      def local
        @local ||= ::EacRubyUtils::Envs::LocalEnv.new
      end

      def ssh(user_hostname)
        ::EacRubyUtils::Envs::SshEnv.new(user_hostname)
      end
    end
  end
end
