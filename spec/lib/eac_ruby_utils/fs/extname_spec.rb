# frozen_string_literal: true

require 'eac_ruby_utils/fs/extname'

RSpec.describe ::EacRubyUtils::Fs, '#extname' do
  describe '#extname' do
    {
      'After.Life.S01E01.WEBRip.x264-ION10.mp4' => '.mp4',
      's01e01.en.srt' => '.en.srt',
      's01e01.srt' => '.srt',
      '/path/to/file.tar.gz' => '.tar.gz'
    }.each do |source, expected|
      context "when source is \"#{source}\"" do
        it { expect(described_class.extname(source)).to eq(expected) }
      end
    end
  end
end
