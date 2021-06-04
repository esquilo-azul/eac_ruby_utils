# frozen_string_literal: true

require 'eac_ruby_utils/speaker/sender'

class Module
  def enable_speaker
    include ::EacRubyUtils::Speaker::Sender
  end
end
