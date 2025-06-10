# frozen_string_literal: true

RSpec.describe Pathname, '#basename_sub' do
  it do
    expect(described_class.new('/absolute/path/to/file').basename_sub { |_b| 'other_file' }).to eq(
      described_class.new('/absolute/path/to/other_file')
    )
  end

  it do
    expect(described_class.new('file').basename_sub { |b| "#{b}_appended" }).to eq(
      described_class.new('file_appended')
    )
  end
end
