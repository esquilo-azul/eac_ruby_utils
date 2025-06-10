# frozen_string_literal: true

RSpec.describe Module, '#speaker' do
  let(:stub_class) do
    Class.new do
      enable_speaker
    end
  end

  describe '#enable_speaker' do
    it { expect(stub_class.included_modules).to include(EacRubyUtils::Speaker::Sender) }
  end
end
