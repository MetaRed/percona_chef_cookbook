#
# Cookbook Name:: percona
# Spec:: binlog_backup
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

describe 'percona::binlog_backup' do
  include_context 'db-backup-credentials'

  context 'BINLOG Backups: on Percona 5.5 Ubuntu 14.04' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '14.04')
      runner.converge(described_recipe)
    end

    pkg_list = [
      'pigz',
      'gzip',
      'tar'
    ]

    dir_list = [
      '/opt/percona_backup_scripts',
      '/var/log/mysql/percona_backups',
      '/percona_backups/binlog_backups'
    ]

    binlog_backup_scripts = [
      '/opt/percona_backup_scripts/percona_binlog_flush.bash',
      '/opt/percona_backup_scripts/percona_binlog_backup.bash',
      '/opt/percona_backup_scripts/percona_binlog_backup_wrapper.bash'
    ]

    it 'include aws_s3 recipe' do
      expect(chef_run).to include_recipe('percona::aws_s3')
    end

    pkg_list.each do |p|
      it "installs apt_package #{p}" do
        expect(chef_run).to install_package(p)
      end
    end

    dir_list.each do |bu_dir|
      it "creates #{bu_dir} backup dir" do
        expect(chef_run).to create_directory(bu_dir.to_s).with(
          user:   'mysql',
          group:  'root',
          mode:    '0755',
          recursive: true
        )
      end
    end

    binlog_backup_scripts.each do |bu_sh|
      it "create #{bu_sh} from templates" do
        expect(chef_run).to create_template(bu_sh.to_s).with(
          user:   'root',
          group:  'root',
          mode: '0755',
          sensitive: true
        )
      end
    end

    it 'creates cron entry for percona_binlog_backup' do
      expect(chef_run).to create_cron('percona_binlog_backup').with(minute: '0')
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
