# frozen_string_literal: true

require 'i18n'
require_relative 'lists'

module EacRubyUtils
  module Listable
    module ClassMethods
      def lists
        @lists ||= ::EacRubyUtils::Listable::Lists.new(self)
      end
    end
  end
end
