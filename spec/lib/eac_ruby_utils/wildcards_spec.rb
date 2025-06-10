# frozen_string_literal: true

RSpec.describe EacRubyUtils::Wildcards do
  describe '#match' do
    {
      'h*llo' => { 'hello' => true, 'hallo' => true, 'hxllo' => true, 'hillo' => true },
      'w?rld' => { 'world' => true, 'warld' => true, 'wzzrld' => false },
      'h*l?o' => { 'hello' => true, 'hallo' => true, 'hxxllo' => true, 'hilbbo' => false },
      '' => { '' => true, 'hello' => false },
      'hello' => { '' => false, 'hello' => true }
    }.each do |pattern, examples|
      context "when pattern is '#{pattern}'" do
        let(:instance) { described_class.new(pattern) }

        examples.each do |string, expected_result|
          context "when string is \"#{string}\"" do
            it do
              expect(instance.match?(string)).to eq(expected_result)
            end
          end
        end
      end
    end
  end
end
