# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('../lib', __dir__)
require 'tmpdir'

require 'i18n'
I18n.load_path << File.join(__dir__, 'locales/pt-BR.yml')
I18n.locale = 'pt-BR' # rubocop:disable Rails/I18nLocaleAssignment

RSpec.configure do |config|
  config.example_status_persistence_file_path = File.join(Dir.tmpdir, 'eac_ruby_utils_rspec')

  require 'eac_ruby_utils/rspec/default_setup'
  EacRubyUtils::Rspec.default_setup_create(File.expand_path('..', __dir__), config)
end
