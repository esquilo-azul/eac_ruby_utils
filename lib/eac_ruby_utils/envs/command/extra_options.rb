# frozen_string_literal: true

require 'active_support/core_ext/hash/indifferent_access'
require 'shellwords'

module EacRubyUtils
  module Envs
    class Command
      module ExtraOptions
        def chdir(dir)
          duplicate_by_extra_options(chdir: dir)
        end

        def envvar(name, value)
          duplicate_by_extra_options(envvars: envvars.merge(name => value))
        end

        def pipe(other_command)
          duplicate_by_extra_options(pipe: other_command)
        end

        private

        attr_reader :extra_options

        def envvars
          extra_options[:envvars] ||= {}.with_indifferent_access
        end

        def append_envvars(command)
          e = envvars.map { |k, v| "#{Shellwords.escape(k)}=#{Shellwords.escape(v)}" }.join(' ')
          e.present? ? "#{e} #{command}" : command
        end

        def append_pipe(command)
          extra_options[:pipe].present? ? "#{command} | #{extra_options[:pipe].command}" : command
        end

        def append_chdir(command)
          extra_options[:chdir].present? ? "(cd '#{extra_options[:chdir]}' ; #{command} )" : command
        end
      end
    end
  end
end
