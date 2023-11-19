# frozen_string_literal: true

require 'eac_ruby_utils/patches/pathname/parent_n'

RSpec.describe Pathname, '#parent_n' do
  [
    ['/absolute/path/to/file', 0, '/absolute/path/to/file'],
    ['/absolute/path/to/file', 1, '/absolute/path/to'],
    ['/absolute/path/to/file', 2, '/absolute/path'],
    ['/absolute/path/to/file', 3, '/absolute'],
    ['/absolute/path/to/file', 4, '/'],
    ['/absolute/path/to/file', 5, '/'],
    ['relative/path/to/file', 0, 'relative/path/to/file'],
    ['relative/path/to/file', 1, 'relative/path/to'],
    ['relative/path/to/file', 2, 'relative/path'],
    ['relative/path/to/file', 3, 'relative'],
    ['relative/path/to/file', 4, '.'],
    ['relative/path/to/file', 5, '..'],
    ['relative/path/to/file', 6, '../..']
  ].each do |test_data|
    input_path = test_data[0]
    context "when path is \"#{input_path}\"" do
      let(:n) { test_data[1] }
      let(:expected_path) { test_data[2] }

      it do
        expect(described_class.new(input_path).parent_n(n)).to(
          eq(described_class.new(expected_path))
        )
      end
    end
  end
end
