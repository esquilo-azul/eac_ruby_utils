# frozen_string_literal: true

require 'eac_ruby_utils/envs/command'
require 'eac_ruby_utils/envs/executable'
require 'eac_ruby_utils/envs/file'

module EacRubyUtils
  module Envs
    class BaseEnv
      def command(*args)
        ::EacRubyUtils::Envs::Command.new(self, args)
      end

      # <b>DEPRECATED:</b> Please use <tt>file(file).exist?</tt> instead.
      def file_exist?(file)
        self.file(file).exist?
      end

      def executable(*executable_new_args)
        ::EacRubyUtils::Envs::Executable.new(self, *executable_new_args)
      end

      def file(path)
        ::EacRubyUtils::Envs::File.new(self, path)
      end
    end
  end
end
