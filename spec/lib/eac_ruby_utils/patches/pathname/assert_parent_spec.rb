# frozen_string_literal: true

require 'eac_ruby_utils/patches/pathname/parent_n'

RSpec.describe ::Pathname do
  let(:root) { temp_dir }
  let(:parent_dir) { root.join('parent_dir') }
  let(:instance) { parent_dir.join('the_file') }
  let(:result) { instance.assert_parent }

  it { expect(parent_dir).not_to exist }
  it { expect(instance).not_to exist }

  context 'when parent is asserted' do
    before { result }

    it { expect(parent_dir).to exist }
    it { expect(instance).not_to exist }
    it { expect(result).to eq(instance) }
  end
end
