# frozen_string_literal: true

RSpec.describe EacRubyUtils::StaticMethodClass do
  let(:sender_class) do
    Class.new do
      class << self
        def sender_value
          'AAA'
        end
      end
    end
  end

  let(:method_class) do
    the_described_class = described_class
    Class.new do
      def self.name
        'TheSender::PerformX'
      end

      include the_described_class

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

  it { expect(sender_class).to respond_to(:perform_x) }
  it { expect(sender_class.perform_x('BBB')).to eq('AAA,BBB') }
end
