# frozen_string_literal: true

RSpec.describe Pathname, '#basename_noext' do
  describe '#basename_noext' do
    {
      'After.Life.S01E01.WEBRip.x264-ION10.mp4' =>
        %w[After.Life.S01E01.WEBRip.x264-ION10 After.Life.S01E01.WEBRip.x264-ION10.mp4
           After.Life.S01E01.WEBRip.x264-ION10 After.Life.S01E01.WEBRip.x264-ION10],
      's01e01.en.srt' => %w[s01e01 s01e01.en.srt s01e01.en s01e01 s01e01],
      's01e01.srt' => %w[s01e01 s01e01.srt s01e01 s01e01 s01e01],
      '/path/to/file.tar.gz' => %w[file file.tar.gz file.tar file file]
    }.each do |source, expected_values|
      expected_values.each_with_index do |expected_value, index|
        limit = index - 1 # rubocop:disable RSpec/LeakyLocalVariable
        context "when source is \"#{source}\" and limit is \"#{limit}\"" do
          let(:instance) { described_class.new(source) }
          let(:expected_path) { described_class.new(expected_value) }

          it { expect(instance.basename_noext(limit)).to eq(expected_path) }
        end
      end
    end
  end
end
