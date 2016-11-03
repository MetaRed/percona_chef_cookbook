#
# Cookbook Name:: percona
# Recipe:: xtradb_backup
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
  end
end

dir_list = [
  node['xtradb']['log_dir'],
  node['xtradb']['backup_dir'],
  node['xtradb']['backup_log_dir'],
  node['xtradb']['backup_script_dir']
]

# create db directories
dir_list.each do |dir|
  directory dir do
    owner 'mysql'
    group 'root'
    mode '0755'
    recursive true
    action :create
  end
end

# decrypted data bag user credentials
percona_creds = data_bag_item('mysql', 'mysql')

# populate script from template
template "#{node['xtradb']['backup_script_dir']}/percona_xtradb_backup.bash" do
  source "/version_#{node['server']['version']}/percona_xtradb_backup.bash.erb"
  owner 'root'
  group 'root'
  mode '0755'
  sensitive true
  variables(
    db_user: percona_creds['db_backup_user'],
    db_passwd: percona_creds['db_backup_user_passwd']
  )
end

# schedule backup script wrapper
cron 'percona_xtradb_backup' do
  minute '10'
  hour '0'
  user 'root'
  command %W(
    "umask 002;
    #{node['xtradb']['backup_script_dir']}/percona_xtradb_backup.bash
    >>#{node['xtradb']['log_dir']}/percona_xtradb_backup.log 2>&1"
  ).join(' ')
end
