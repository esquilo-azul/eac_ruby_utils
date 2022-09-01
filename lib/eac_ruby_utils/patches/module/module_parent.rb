# frozen_string_literal: true

require 'active_support/core_ext/module/introspection'

::Module.alias_method :module_parent, :parent unless ::Module.method_defined?(:module_parent)
