# frozen_string_literal: true

RSpec.describe EacRubyUtils::MethodClass do
  it_behaves_like 'acts_as_method' do
    before do
      method_class.include(described_class)
    end

    let(:sender_object) { sender_class.new('AAA') }
  end
end
