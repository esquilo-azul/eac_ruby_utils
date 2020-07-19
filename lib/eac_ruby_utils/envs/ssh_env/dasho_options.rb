# frozen_string_literal: true

require 'eac_ruby_utils/patches/module/common_concern'
require 'eac_ruby_utils/patches/module/simple_cache'

module EacRubyUtils
  module Envs
    class SshEnv < ::EacRubyUtils::Envs::BaseEnv
      module DashoOptions
        common_concern

        module ClassMethods
          def add_nodasho_option(name)
            return if nodasho_options.include?(name)

            nodasho_options << name
            const_set("#{name.underscore}_option".upcase, name)
          end

          def nodasho_options
            @nodasho_options ||= []
          end
        end

        module InstanceMethods
          def ssh_command_line_dasho_args
            r = []
            uri.query_values&.each do |k, v|
              r += ['-o', "#{k}=#{v}"] unless nodasho_options.include?(k)
            end
            r
          end

          def ssh_command_line_nodasho_args
            nodasho_options.flat_map do |option_name|
              uri_query_value(option_name).if_present([]) do |option_value|
                send("ssh_command_line_#{option_name.underscore}_args", option_value)
              end
            end
          end

          def nodasho_options
            self.class.nodasho_options
          end

          def uri_query_value(name)
            uri.query_values.if_present { |v| v[name] }
          end
        end
      end
    end
  end
end
