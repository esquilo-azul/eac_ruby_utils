# frozen_string_literal: true

RSpec.describe EacRubyUtils::EnumerablesMethods do
  describe '#write_method?' do
    it do
      expect(described_class).to be_write_method(:'[]=')
    end

    it do
      expect(described_class).not_to be_write_method(:'!=')
    end
  end

  [
    [:enumerable, %i[drop lazy sort], []],
    [:hash, %i[\[\] <= compact slice to_h values],
     %i[\[\]= compact! delete default= keep_if shift]],
    [:set, %i[<= include?], %i[<< add clear collect! divide delete keep_if merge reset subtract]]
  ].each do |test_values|
    klass_underscore, read_methods, write_methods = test_values

    context "when class/module is #{klass_underscore}" do
      let(:const_prefix) { klass_underscore.to_s.upcase }
      let(:const_all) { "#{const_prefix}_METHODS" }
      let(:const_read) { "#{const_prefix}_READ_METHODS" }
      let(:const_write) { "#{const_prefix}_WRITE_METHODS" }
      let(:actual_all) { described_class.const_get(const_all) }
      let(:actual_read) { described_class.const_get(const_read) }
      let(:actual_write) { described_class.const_get(const_write) }

      read_methods.each do |method_name|
        context "when method is \"#{method_name}\"" do
          it { expect(actual_all).to include(method_name) }
          it { expect(actual_read).to include(method_name) }
          it { expect(actual_write).not_to include(method_name) }
        end
      end

      write_methods.each do |method_name|
        context "when method is \"#{method_name}\"" do
          it { expect(actual_all).to include(method_name) }
          it { expect(actual_read).not_to include(method_name) }
          it { expect(actual_write).to include(method_name) }
        end
      end
    end
  end
end
