# frozen_string_literal: true

RSpec.describe EacRubyUtils::ActsAsStaticMethod do
  it_behaves_like 'acts_as_method' do
    before do
      sender_class.sender_value = 'AAA'
      described_class.new(method_class).setup
    end

    let(:sender_object) { sender_class }
  end
end
