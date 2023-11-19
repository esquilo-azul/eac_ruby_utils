# frozen_string_literal: true

require 'eac_ruby_utils/patches/string/delimited'

::RSpec.describe ::String, '#delimeted' do # rubocop:disable RSpec/FilePath, RSpec/SpecFilePathFormat
  let(:instance) { 'A text with <b>content between</b> tags.' }

  {
    ['<b>', '</b>'] => {
      'inner' => 'content between',
      'without_inner' => 'A text with <b></b> tags.',
      'outer' => '<b>content between</b>',
      'without_outer' => 'A text with  tags.'
    },
    ['<b>', '</br>'] => {
      'inner' => '',
      'without_inner' => 'A text with <b>content between</b> tags.',
      'outer' => '',
      'without_outer' => 'A text with <b>content between</b> tags.'
    }
  }.each do |delimiters, expected_values|
    context "when delimiters are #{delimiters}" do
      let(:bdel) { delimiters[0] }
      let(:edel) { delimiters[1] }

      expected_values.each do |method_suffix, expected_value|
        method_name = "delimited_#{method_suffix}"
        it "#{method_name} should return \"#{expected_value}\"" do
          expect(instance.send(method_name, bdel, edel)).to eq(expected_value)
        end
      end
    end
  end
end
