# frozen_string_literal: true

require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/hash/slice'
require 'docopt'
require 'eac_ruby_utils/patches/hash/sym_keys_hash'
Dir["#{__dir__}/#{::File.basename(__FILE__, '.*')}/_*.rb"].each do |partial|
  require partial
end

module EacRubyUtils
  module Console
    class DocoptRunner
      attr_reader :options, :settings

      def initialize(settings = {})
        @settings = settings.with_indifferent_access.freeze
        @options = Docopt.docopt(target_doc, docopt_options)
      end

      protected

      def docopt_options
        settings.slice(:version, :argv, :help, :options_first).to_sym_keys_hash
      end
    end
  end
end
