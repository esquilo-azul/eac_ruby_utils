# frozen_string_literal: true

require 'eac_ruby_utils/templates/searcher'

RSpec.describe ::EacRubyUtils::Templates::Searcher do
  let(:files_dir) { ::File.join(__dir__, 'searcher_spec_files') }
  let(:instance) do
    r = described_class.new
    r.included_paths << ::File.join(files_dir, 'path1')
    r.included_paths << ::File.join(files_dir, 'path2')
    r
  end

  describe '#template' do
    {
      ::EacRubyUtils::Templates::Directory => %w[subdir1],
      ::EacRubyUtils::Templates::File => %w[subdir1/file1.template subdir1/file2
                                            subdir1/file3.template],
      ::NilClass => %w[does_not_exist]
    }.each do |klass, subpaths|
      subpaths.each do |subpath|
        context "when subpath is \"#{subpath}\"" do
          it "returns a #{klass}'s instance" do
            expect(instance.template(subpath, false)).to be_a(klass)
          end
        end
      end
    end
  end
end
