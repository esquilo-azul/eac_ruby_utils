# frozen_string_literal: true

module EacRubyUtils
  module Speaker
    module Sender
      delegate :error, :fatal_error, :info, :infom, :title, :success, :warn, to: :speaker_receiver

      def infov(*args)
        speaker_receiver.infov(*args)
      end

      delegate :out, to: :speaker_receiver

      delegate :puts, to: :speaker_receiver

      # Shortcut to [EacRubyUtils::Speaker.current_receiver].
      #
      # @return [EacRubyUtils::Speaker::Receiver]
      def speaker_receiver
        ::EacRubyUtils::Speaker.current_receiver
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
