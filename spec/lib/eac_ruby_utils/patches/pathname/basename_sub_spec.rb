# frozen_string_literal: true

require 'eac_ruby_utils/patches/pathname/basename_sub'

RSpec.describe ::Pathname do
  it do
    expect(::Pathname.new('/absolute/path/to/file').basename_sub { |_b| 'other_file' }).to eq(
      ::Pathname.new('/absolute/path/to/other_file')
    )
  end

  it do
    expect(::Pathname.new('file').basename_sub { |b| b.to_s + '_appended' }).to eq(
      ::Pathname.new('file_appended')
    )
  end
end
