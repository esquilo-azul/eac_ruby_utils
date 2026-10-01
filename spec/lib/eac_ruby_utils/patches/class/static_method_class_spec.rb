# frozen_string_literal: true

RSpec.describe Class, '#static_method' do
  it_behaves_like 'acts_as_method' do
    before do
      sender_class.sender_value = 'AAA'
      method_class.enable_static_method_class
    end

    let(:sender_object) { sender_class }
  end
end
