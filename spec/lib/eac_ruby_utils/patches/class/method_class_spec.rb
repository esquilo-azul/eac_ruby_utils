# frozen_string_literal: true

RSpec.describe Class, '#method_class' do
  it_behaves_like 'acts_as_method' do
    before do
      method_class.enable_method_class
    end

    let(:sender_object) { sender_class.new('AAA') }
  end
end
