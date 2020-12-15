# frozen_string_literal: true

module EacRubyUtils
  module Envs
    class Command
      module Envvars
        def envvar(name, value)
          duplicate_by_extra_options(envvars: envvars.merge(name => value))
        end

        private

        def append_envvars(command)
          e = envvars.map { |k, v| "#{Shellwords.escape(k)}=#{Shellwords.escape(v)}" }.join(' ')
          e.present? ? "#{e} #{command}" : command
        end

        def envvars
          extra_options[:envvars] ||= {}.with_indifferent_access
        end
      end
    end
  end
end
