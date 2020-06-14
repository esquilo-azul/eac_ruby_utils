# frozen_string_literal: true

require 'eac_ruby_utils/configs'
require 'eac_ruby_utils/templates/file'

RSpec.describe ::EacRubyUtils::Templates::File do
  let(:files_dir) { ::File.join(__dir__, 'file_spec_files') }
  let(:source_path) { ::File.join(files_dir, 'source.template') }
  let(:instance) { described_class.new(source_path) }
  let(:expected_content) { ::File.read(::File.join(files_dir, 'expected_content')) }

  describe '#apply' do
    context 'when config is a hash' do
      let(:config) { { name: 'Fulano de Tal', age: 33 } }

      it { expect(instance.apply(config)).to eq(expected_content) }
    end

    context 'when config responds to read_entry' do
      let(:config) { ::EacRubyUtils::Configs.new('rspec_describe_eac_ruby_utils_templates_file') }

      before do
        config.clear
        config['name'] = 'Fulano de Tal'
        config['age'] = '33'
      end

      it { expect(instance.apply(config)).to eq(expected_content) }
    end
  end

  describe '#variables' do
    it { expect(instance.variables).to eq(::Set.new(%w[name age])) }
  end
end
