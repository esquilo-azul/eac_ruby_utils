# frozen_string_literal: true

RSpec.describe EacRubyUtils::StaticMethodClass do
  it_behaves_like 'acts_as_method' do
    before do
      sender_class.sender_value = 'AAA'
      method_class.include(described_class)
    end

    let(:sender_object) { sender_class }
  end
end
