# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'eac_ruby_utils/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'eac_ruby_utils'
  s.version     = ::EacRubyUtils::VERSION
  s.authors     = ['Esquilo Azul Company']
  s.summary     = 'Utilities for E.A.C.\'s Ruby projects.'
  s.license     = 'MIT'

  s.files = Dir['{lib}/**/*', 'MIT-LICENSE', 'README.rdoc']

  s.add_dependency 'colorize', '~> 0.8.1'
  s.add_dependency 'docopt', '~> 0.6.1'
  s.add_dependency 'net-ssh', '~> 4.2'
end
