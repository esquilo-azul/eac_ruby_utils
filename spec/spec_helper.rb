# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('../lib', __dir__)
require 'tmpdir'

RSpec.configure do |config|
  config.example_status_persistence_file_path = ::File.join(::Dir.tmpdir, 'eac_ruby_utils_rspec')
end

require 'i18n'
::I18n.load_path << ::File.join(__dir__, 'locales/pt-BR.yml')
::I18n.locale = 'pt-BR'
