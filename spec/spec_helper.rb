# frozen_string_literal: true

require 'i18n'
I18n.load_path << File.join(__dir__, 'locales/pt-BR.yml')
I18n.locale = 'pt-BR' # rubocop:disable Rails/I18nLocaleAssignment

require 'eac_ruby_utils'
require 'eac_ruby_gem_support'
require 'avm/eac_ubuntu_base0'
EacRubyUtils::Rspec.default_setup_create(File.expand_path('..', __dir__))
