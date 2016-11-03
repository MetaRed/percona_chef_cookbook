#
# Cookbook Name:: percona
# Recipe:: binlog_backup
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

# install and configure binlog backup script dependencies
include_recipe 'percona::aws_s3'

# define packages
packages = [
  'pigz',
  'gzip',
  'tar'
]

# install packages
packages.each do |p|
  package p do
    action :install
  end
end

# make binlog backup dir
dir_list = [
  node['server']['binlog_backup']['backup_dir'],
  node['server']['backup_log_dir'],
  node['server']['backup_script_dir']
]

dir_list.each do |dir|
  directory dir do
    owner 'mysql'
    group 'root'
    mode '0755'
    recursive true
    action :create
  end
end

# define binlog backup script files
binlog_backup_scripts = [
  'percona_binlog_flush.bash',
  'percona_binlog_backup.bash',
  'percona_binlog_backup_wrapper.bash'
]

# decrypted data bag user credentials
percona_creds = data_bag_item('mysql', 'mysql')

# populate scripts from template
binlog_backup_scripts.each do |bash_file|
  template "#{node['server']['backup_script_dir']}/#{bash_file}" do
    source "/version_#{node['server']['version']}/#{bash_file}.erb"
    owner 'root'
    group 'root'
    mode '0755'
    sensitive true
    variables(
      db_user: percona_creds['db_backup_user'],
      db_passwd: percona_creds['db_backup_user_passwd']
    )
  end
end

# schedule binlog backup script wrapper
cron 'percona_binlog_backup' do
  minute '0'
  user 'root'
  command %W(
    "umask 002;
    #{node['server']['backup_script_dir']}/percona_binlog_backup_wrapper.bash
    >>#{node['server']['backup_log_dir']}/percona_binlog_backup.log 2>&1"
  ).join(' ')
end
