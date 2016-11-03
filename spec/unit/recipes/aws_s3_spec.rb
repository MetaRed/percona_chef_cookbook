#
# Cookbook Name:: percona
# Spec:: aws_s3
#
# The MIT License (MIT)
#
# Copyright (c) 2015 Richard Lopez
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require 'spec_helper'

describe 'percona::aws_s3' do
  include_context 'db-backup-credentials'

  context 'AWSCLI-Bundle: on Percona 5.5 Ubuntu 14.04' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '14.04')
      runner.converge(described_recipe)
    end

    def file_mock(file, exist)
      allow(File).to receive(:exist?).and_call_original
      allow(File).to receive(:exist?).with(file).and_return(exist)
    end

    it 'installs apt_package unzip package' do
      expect(chef_run).to install_package('unzip')
    end

    it 'download awscli-bundle.zip if not installed' do
      file_mock('/usr/local/bin/aws', false)
      expect(chef_run).to create_remote_file('/opt/awscli-bundle.zip').with(
        owner: 'root',
        group: 'root'
      )
      chef_run.converge(described_recipe)
    end

    it 'do not download awscli-bundle.zip if installed' do
      file_mock('/usr/local/bin/aws', true)
      expect(chef_run).to_not create_remote_file('/opt/awscli-bundle.zip').with(
        owner: 'root',
        group: 'root'
      )
      chef_run.converge(described_recipe)
    end

    it 'awscli-bundle notifies install_awscli_script' do
      aws_file = chef_run.remote_file('/opt/awscli-bundle.zip')
      expect(aws_file).to notify(
        'bash[install_awscli_script]').to(:run).immediately
    end

    it 'install_awscli_script only runs when notified' do
      awscli_install = chef_run.bash('install_awscli_script')
      expect(awscli_install).to do_nothing
    end

    it 'configure awscli-bundle.zip if installed' do
      file_mock('/usr/local/bin/aws', true)
      expect(chef_run).to run_bash('configure_awscli_script')
      chef_run.converge(described_recipe)
    end

    it 'do not configure awscli-bundle.zip if not installed' do
      file_mock('/usr/local/bin/aws', false)
      expect(chef_run).to_not run_bash('configure_awscli_script')
      chef_run.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
