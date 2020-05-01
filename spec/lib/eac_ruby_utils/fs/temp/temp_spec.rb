# frozen_string_literal: true

require 'eac_ruby_utils/fs/temp/directory'

RSpec.describe ::EacRubyUtils::Fs::Temp::Directory do
  describe '#remove!' do
    let(:instance) { described_class.new }

    it { expect(instance).to be_directory }
    it { expect { instance.remove! }.to_not raise_error }
  end
end
