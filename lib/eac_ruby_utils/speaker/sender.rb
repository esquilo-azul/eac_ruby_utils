# frozen_string_literal: true

require 'eac_ruby_utils/compact'

module EacRubyUtils
  module Speaker
    module Sender
      delegate :error, :fatal_error, :info, :infom, :infov, :out, :puts, :title, :success, :warn,
               to: :speaker_receiver

      # Shortcut to [EacRubyUtils::Speaker.current_receiver].
      #
      # @return [EacRubyUtils::Speaker::Receiver]
      def speaker_receiver
        ::EacRubyUtils::Speaker.current_receiver
      end

      # @param attributes [Enumerable<Symbol>] Attributes for +EacRubyUtils::Compact.new+.
      # @return [self]
      def compact_infov(*attributes)
        ::EacRubyUtils::Compact.new(self, attributes).to_h.each do |k, v|
          infov k, v
        end

        self
      end

      # Options:
      #   +bool+ ([Boolean], default: +false+): requires a answer "yes" or "no".
      #   +list+ ([Hash] or [Array], default: +nil+): requires a answer from a list.
      #   +noecho+ ([Boolean], default: +false+): does not output answer.
      def input(question, options = {})
        speaker_receiver.input(question, options)
      end
    end
  end
end
