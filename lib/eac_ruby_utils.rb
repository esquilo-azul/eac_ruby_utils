# frozen_string_literal: true

require 'eac_ruby_utils/root_module_setup'
EacRubyUtils::RootModuleSetup.perform __FILE__ do
  ignore 'core_ext'
  ignore 'locales/from_all_gems'
  ignore 'patches'
  ignore 'ruby/on_clean_environment'
end

module EacRubyUtils
  include ::EacRubyUtils::PatchModule
end

require 'eac_ruby_utils/core_ext'
