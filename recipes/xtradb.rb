#
# Cookbook Name:: percona
# Recipe:: xtradb
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

apt_repository 'percona_xtradb_cluster' do
  uri 'http://repo.percona.com/apt'
  distribution node['lsb']['codename']
  components ['main']
  keyserver 'keys.gnupg.net'
  key '1C4CBDCDCD2EFD2A'
  action :add
end

# update key and repo before installing packages
execute 'update_apt_key' do
  command 'apt-key update'
  user 'root'
  action :run
end

execute 'update_apt_repo' do
  command 'apt-get update'
  user 'root'
  action :run
end

# define packages
apt_packages = [
  "percona-xtradb-cluster-server-#{node['xtradb']['version']}",
  "percona-xtradb-cluster-client-#{node['xtradb']['version']}",
  'percona-toolkit',
  'percona-xtrabackup'
]

# install packages
apt_packages.each do |p|
  package p do
    action :install
    options '--force-yes'
  end
end

dir_list = [
  node['xtradb']['data_dir'],
  node['xtradb']['log_dir']
]

# create db directories
dir_list.each do |dir|
  directory dir do
    owner 'mysql'
    group 'mysql'
    mode '0775'
    recursive true
    action :create
  end
end

# decrypted data bag xtradb credentials
auth = data_bag_item('xtradb', 'xtradb')

# custom percona config settings
template '/etc/mysql/my.cnf' do
  source "version_#{node['xtradb']['version']}/xtradb_my.cnf.erb"
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    cluster_auth: auth['wsrep_sst_auth']
  )
end

# setup mysql database schema
execute 'install_mysql_db_schema' do
  command 'mysql_install_db --defaults-file=/etc/mysql/my.cnf'
  user 'root'
  action :run
end

# configure the MySQL service.
service 'mysql' do
  action [:enable, :start]
end
