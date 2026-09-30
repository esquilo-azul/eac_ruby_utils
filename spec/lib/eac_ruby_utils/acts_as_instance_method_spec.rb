# frozen_string_literal: true

RSpec.describe EacRubyUtils::ActsAsInstanceMethod do
  it_behaves_like 'acts_as_method' do
    before do
      described_class.new(method_class).setup
    end

    let(:sender_object) { sender_class.new('AAA') }
  end
end
