# frozen_string_literal: true

RSpec.describe Class, '#acts_as_instance_method' do
  it_behaves_like 'acts_as_method' do
    before do
      method_class.acts_as_instance_method
    end

    let(:sender_object) { sender_class.new('AAA') }
  end
end
