# frozen_string_literal: true

require 'avm/eac_ubuntu_base0/rspec/ssh_docker_server'

require_relative 'base_example'

RSpec.describe EacRubyUtils::Envs::Command, '#ssh_env' do
  let(:ssh_server) { Avm::EacUbuntuBase0::Rspec::SshDockerServer.new }
  let(:env) { ssh_server.env }

  around do |example|
    ssh_server.on_run(&example)
  end

  it_behaves_like 'with_command_env'
end
