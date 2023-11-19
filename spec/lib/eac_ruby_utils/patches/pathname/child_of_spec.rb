# frozen_string_literal: true

require 'eac_ruby_utils/patches/pathname/child_of'

RSpec.describe ::Pathname, '#child_of' do
  describe 'child_of?' do
    [
      ['/foo/bar/baz', '/foo/bar', true],
      ['/foo/../foo/bar/../bar/baz', '/foo/bar', true],
      ['/foo/bar/baz', '/foo/../foo/bar/../bar', true],
      ['/foo/bar/baz', '/boink', false],
      ['/foo/bar/../not_bar/baz', '/foo/bar', false],
      ['/foo/bar/../bar_not/baz', '/foo/bar', false],
      ['/foo', '/foo/bar', false],
      ['/foo', '/bar', false],
      ['/foo', '/foo', false]
    ].each do |test_values|
      child_path, parent_path, expected_value = test_values
      context "when child=\"#{child_path}\" and parent=\"#{parent_path}\"" do
        it do
          expect(Pathname(child_path).child_of?(Pathname(parent_path))).to be(expected_value)
        end
      end
    end
  end
end
