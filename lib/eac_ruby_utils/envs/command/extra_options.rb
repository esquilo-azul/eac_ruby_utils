# frozen_string_literal: true

module EacRubyUtils
  module Envs
    class Command
      module ExtraOptions
        def chdir(dir)
          @chdir = dir
          self
        end

        def envvar(name, value)
          @envvars[name] = value
          self
        end

        def pipe(other_command)
          @pipe = other_command
          self
        end

        private

        def append_envvars(command)
          e = @envvars.map { |k, v| "#{Shellwords.escape(k)}=#{Shellwords.escape(v)}" }.join(' ')
          e.present? ? "#{e} #{command}" : command
        end

        def append_pipe(command)
          @pipe.present? ? "#{command} | #{@pipe.command}" : command
        end

        def append_chdir(command)
          @chdir.present? ? "(cd '#{@chdir}' ; #{command} )" : command
        end
      end
    end
  end
end
