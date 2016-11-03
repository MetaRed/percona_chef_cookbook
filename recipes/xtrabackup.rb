#
# Cookbook Name:: percona
# Recipe:: xtrabackup
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

# install and configure full backup script dependencies
include_recipe 'percona::aws_s3'

# define packages
packages = [
  'percona-xtrabackup',
  'pigz',
  'gzip',
  'tar'
]

# install packages
packages.each do |p|
  package p do
    action :install
    options '--force-yes'
  end
end

dir_list = [
  node['server']['xtrabackup']['backup_dir'],
  node['server']['backup_script_dir'],
  node['server']['backup_log_dir']
]

# create db directories
dir_list.each do |dir|
  directory dir do
    owner 'mysql'
    group 'root'
    mode '0775'
    recursive true
    action :create
  end
end

# define backup script files
backup_scripts = [
  'percona_backup.bash',
  'percona_backup_wrapper.bash',
  'percona_structure_backup.bash',
  'percona_backup_compressor.bash',
  'percona_backup_aws_archive.bash'
]

# decrypted data bag user credentials
percona_creds = data_bag_item('mysql', 'mysql')

# populate scripts from template
backup_scripts.each do |bash_file|
  template "#{node['server']['backup_script_dir']}/#{bash_file}" do
    source "/version_#{node['server']['version']}/#{bash_file}.erb"
    owner 'root'
    group 'root'
    mode '0775'
    sensitive true
    variables(
      db_user: percona_creds['db_backup_user'],
      db_passwd: percona_creds['db_backup_user_passwd']
    )
  end
end

# schedule backup script wrapper
cron 'percona_server_backup' do
  minute '10'
  hour '0'
  user 'root'
  command %W(
    "umask 002;
    #{node['server']['backup_script_dir']}/percona_backup_wrapper.bash
    >>#{node['server']['backup_log_dir']}/percona_backup.log 2>&1"
  ).join(' ')
end
