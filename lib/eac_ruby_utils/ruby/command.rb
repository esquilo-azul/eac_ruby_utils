# frozen_string_literal: true

require 'eac_ruby_utils/envs/command'
require 'eac_ruby_utils/ruby/on_clean_environment'

module EacRubyUtils
  module Ruby
    # A [EacRubyUtils::Envs::Command] which runs in a clean Ruby environment.
    class Command < ::EacRubyUtils::Envs::Command
      def initialize(bundle_args, extra_options = {})
        super(::EacRubyUtils::Envs.local, bundle_args, extra_options)
      end

      %w[system execute].each do |method_prefix|
        [method_prefix, "#{method_prefix}!"].each do |method_name|
          define_method method_name do |*args, &block|
            ::EacRubyUtils::Ruby.on_clean_environment do
              super(*args, &block)
            end
          end
        end
      end

      protected

      def duplicate(command, extra_options)
        self.class.new(gem, command, extra_options)
      end
    end
  end
end
