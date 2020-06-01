# frozen_string_literal: true

require 'eac_ruby_utils/patches/object/template'

RSpec.describe ::Object do
  class MyStubWithTemplate
  end

  let(:instance) { ::MyStubWithTemplate.new }
  let(:templates_path) { ::File.join(__dir__, 'template_spec_files', 'path') }

  before do
    ::EacRubyUtils::Templates::Searcher.default.included_paths.add(templates_path)
  end

  after do
    ::EacRubyUtils::Templates::Searcher.default.included_paths.delete(templates_path)
  end

  describe '#template' do
    it { expect(instance.template).to be_a(::EacRubyUtils::Templates::File) }
  end
end
