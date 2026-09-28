# frozen_string_literal: true

RSpec.describe Class, '#acts_as_static_method' do
  it_behaves_like 'acts_as_method' do
    before do
      sender_class.sender_value = 'AAA'
      method_class.acts_as_static_method
    end

    let(:sender_object) { sender_class }
  end
end
