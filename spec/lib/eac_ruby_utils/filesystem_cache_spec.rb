# frozen_string_literal: true

require 'active_support/core_ext/object/blank'
require 'eac_ruby_utils/filesystem_cache'

RSpec.describe ::EacRubyUtils::FilesystemCache do
  let(:tmpdir) { ::Dir.mktmpdir }
  let(:instance) { described_class.new(tmpdir, 'instance') }

  it { expect(instance.read).to be_blank }
  it { expect(instance.cached?).to eq(false) }

  context 'when instance is writed' do
    before { instance.write('STUB') }

    it { expect(instance.read).to eq('STUB') }
    it { expect(instance.cached?).to eq(true) }

    context 'when instance is cleared' do
      before { instance.clear }

      it { expect(instance.read).to be_blank }
      it { expect(instance.cached?).to eq(false) }
    end
  end

  describe '#child' do
    let(:child) { instance.child('child') }

    it { expect(child.path).to match(/\A#{::Regexp.quote(instance.path)}/) }
  end
end
