# frozen_string_literal: true

require 'active_support/concern'
Dir["#{__dir__}/#{File.basename(__FILE__, '.*')}/*.rb"].sort.each do |partial|
  require partial
end

module EacRubyUtils
  module Listable
    extend ActiveSupport::Concern

    included do
      extend(ClassMethods)
      include(InstanceMethods)
    end
  end
end
