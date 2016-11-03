#
# Cookbook Name:: percona
# Spec:: server
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

describe 'percona::server' do
  context 'Percona Server: version 5.5 on Ubuntu 14.04' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '14.04')
      runner.converge(described_recipe)
    end

    pkg_list = [
      'percona-server-server-5.5',
      'percona-server-client-5.5',
      'percona-toolkit'
    ]

    dir_list = [
      '/data/mysql',
      '/log/data/mysql',
      '/var/log/mysql'
    ]

    def file_mock(file, exist)
      allow(File).to receive(:exist?).and_call_original
      allow(File).to receive(:exist?).with(file).and_return(exist)
    end

    it 'installs percona apt_repository' do
      expect(chef_run).to add_apt_repository('percona')
    end

    it 'update apt key ring' do
      expect(chef_run).to run_execute('update_apt_key')
    end

    it 'update apt repo' do
      expect(chef_run).to run_execute('update_apt_repo')
    end

    pkg_list.each do |p|
      it "install apt_package #{p}" do
        expect(chef_run).to install_package(p)
      end
    end

    it 'create mysql.cnf template if dir exists' do
      file_mock('/etc/mysql', true)
      expect(chef_run).to create_template('/etc/mysql/my.cnf').with(
        user:   'root',
        group:  'root',
        mode: '0644'
      )
    end

    it 'do not create mysql.cnf template w/o dir' do
      file_mock('/etc/mysql', false)
      expect(chef_run).to_not create_template('/etc/mysql/my.cnf').with(
        user:   'root',
        group:  'root',
        mode: '0644'
      )
    end

    dir_list.each do |db_dir|
      it "create the #{db_dir} db directory with perms" do
        expect(chef_run).to create_directory(db_dir.to_s).with(
          user:   'mysql',
          group:  'mysql',
          mode:    '0775'
        )
      end
    end

    it 'create mysql startup script' do
      expect(chef_run).to create_template('/etc/init.d/mysql').with(
        user:   'root',
        group:  'root',
        mode: '0755'
      )
    end

    it 'start and enables db service' do
      expect(chef_run).to enable_service('mysql')
      expect(chef_run).to start_service('mysql')
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
