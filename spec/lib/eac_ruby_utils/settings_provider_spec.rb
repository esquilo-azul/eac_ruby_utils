# frozen_string_literal: true

require 'eac_ruby_utils/settings_provider'

RSpec.describe ::EacRubyUtils::SettingsProvider do
  let(:stub_class) do
    the_described_class = described_class
    r = ::Class.new do
      include the_described_class

      def key_a
        'method_a'
      end

      def key_b
        'method_b'
      end

      def settings
        { 'key_b' => 'setting_b', key_c: 'setting_c' }
      end
    end
    r.const_set(:KEY_A, 'constant_a')
    r.const_set(:KEY_D, 'constant_d')
    r
  end

  let(:stub) { stub_class.new }

  describe '#setting_value' do
    {
      ['key_a'] => 'method_a',
      [:key_b] => 'setting_b',
      ['key_b', { order: %w[constant method settings_object] }] => 'method_b',
      ['key_c'] => 'setting_c',
      ['key_d'] => 'constant_d'
    }.each do |args, expected_value|
      it { expect(stub.setting_value(*args)).to eq(expected_value) }
    end

    it do
      expect { stub.setting_value('key_e') }.to raise_error(::StandardError)
    end

    it do
      expect(stub.setting_value('key_e', required: false)).to eq(nil)
    end

    it do
      expect(stub.setting_value('key_e', default: nil)).to eq(nil)
    end

    it do
      expect(stub.setting_value('key_e', default: 'default_e')).to eq('default_e')
    end
  end
end
