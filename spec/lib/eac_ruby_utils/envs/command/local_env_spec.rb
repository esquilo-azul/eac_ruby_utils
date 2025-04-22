# frozen_string_literal: true

require 'eac_ruby_utils/envs/command'
require 'eac_ruby_utils/envs/local_env'
require_relative 'base_example'

RSpec.describe EacRubyUtils::Envs::Command, '#local_env' do
  let(:env) { EacRubyUtils::Envs::LocalEnv.new }

  it_behaves_like 'with_command_env'
end
