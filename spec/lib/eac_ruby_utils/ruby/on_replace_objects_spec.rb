# frozen_string_literal: true

require 'eac_ruby_utils/ruby'

RSpec.describe ::EacRubyUtils::Ruby do
  describe '#on_replace_objects' do
    let(:stub_class) do
      ::Class.new do
        def self.my_class_method
          'Original'
        end

        def my_instance_method
          'Original'
        end
      end
    end

    let(:stub_instance) { stub_class.new }

    let(:replace_block) do
      ::Proc.new { 'Replaced' }
    end

    describe '#my_instance_method' do
      let(:before) { stub_instance.my_instance_method }
      let(:inside) do
        described_class.on_replace_objects do |replacer|
          replacer.replace_instance_method(stub_class, :my_instance_method, &replace_block)
          stub_instance.my_instance_method
        end
      end
      let(:after) { stub_instance.my_instance_method }

      before do
        before
        inside
        after
      end

      it { expect(before).to eq('Original') }
      it { expect(inside).to eq('Replaced') }
      it { expect(after).to eq('Original') }
    end

    describe '#replace_self_method' do
      let(:before) { stub_class.my_class_method }
      let(:inside) do
        described_class.on_replace_objects do |replacer|
          replacer.replace_self_method(stub_class, :my_class_method, &replace_block)
          stub_class.my_class_method
        end
      end
      let(:after) { stub_class.my_class_method }

      before do
        before
        inside
        after
      end

      it { expect(before).to eq('Original') }
      it { expect(inside).to eq('Replaced') }
      it { expect(after).to eq('Original') }
    end
  end
end
