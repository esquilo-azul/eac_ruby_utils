# frozen_string_literal: true

RSpec.shared_context 'acts_as_method' do # rubocop:disable RSpec/ContextWording
  let(:sender_class) do
    Class.new do
      cattr_accessor :sender_value
      attr_accessor :sender_value

      def initialize(sender_value)
        self.sender_value = sender_value
      end
    end
  end

  let(:method_class) do
    Class.new do
      def self.name
        'TheSender::PerformX'
      end

      attr_accessor :sender, :method_param

      def initialize(sender, method_param)
        self.sender = sender
        self.method_param = method_param
      end

      def result
        "#{sender.sender_value},#{method_param}"
      end
    end
  end

  before do
    Object.const_set('TheSender', sender_class)
    sender_class.const_set('PerformX', method_class)
  end

  it { expect(sender_object).to respond_to(:perform_x) }
  it { expect(sender_object.perform_x('BBB')).to eq('AAA,BBB') }
end
