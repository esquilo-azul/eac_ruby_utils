# frozen_string_literal: true

require 'avm/eac_ubuntu_base0/rspec/ssh_docker_server'
require 'eac_ruby_utils/envs/command'
require 'eac_ruby_utils/envs/ssh_env'
require_relative 'base_example'

::RSpec.describe ::EacRubyUtils::Envs::Command do
  let(:ssh_server) { ::Avm::EacUbuntuBase0::Rspec::SshDockerServer.new }
  let(:env) { ssh_server.env }

  around do |example|
    ssh_server.on_run(&example)
  end

  include_examples 'with_command_env'
end
