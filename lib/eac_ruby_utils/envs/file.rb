# frozen_string_literal: true

module EacRubyUtils
  module Envs
    class File
      attr_reader :env, :path

      def initialize(env, path)
        @env = env
        @path = path
      end

      def exist?
        env.command('stat', path).execute[:exit_code].zero?
      end

      def read
        env.command('cat', path).execute!
      end
    end
  end
end
