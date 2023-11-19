# frozen_string_literal: true

require 'eac_ruby_utils/patches/pathname/basename_sub'

RSpec.describe ::Pathname, '#basename_sub' do
  it do
    expect(described_class.new('/absolute/path/to/file').basename_sub { |_b| 'other_file' }).to eq(
      described_class.new('/absolute/path/to/other_file')
    )
  end

  it do
    expect(described_class.new('file').basename_sub { |b| b.to_s + '_appended' }).to eq(
      described_class.new('file_appended')
    )
  end
end
