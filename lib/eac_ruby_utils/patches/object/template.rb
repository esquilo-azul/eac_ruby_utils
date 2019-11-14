# frozen_string_literal: true

require 'active_support/core_ext/string/inflections'
require 'eac_ruby_utils/templates/searcher'

class Object
  class << self
    def template
      @template ||= ::EacRubyUtils::Templates::Searcher.default.template(name.underscore)
    end
  end

  def template
    self.class.template
  end
end
