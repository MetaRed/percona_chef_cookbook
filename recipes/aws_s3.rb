#
# Cookbook Name:: percona
# Recipe:: aws_s3
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

# aws install dependencies
package 'unzip' do
  action :install
end

# download latest awscli build and call install scippt if not installed
remote_file '/opt/awscli-bundle.zip' do
  source 'https://s3.amazonaws.com/aws-cli/awscli-bundle.zip'
  owner 'root'
  group 'root'
  notifies :run, 'bash[install_awscli_script]', :immediate
  not_if { File.exist?('/usr/local/bin/aws') }
end

# run install script when called upon
bash 'install_awscli_script' do
  user 'root'
  group 'root'
  cwd '/opt'
  code <<-EOH
  unzip awscli-bundle.zip
  ./awscli-bundle/install -i /usr/local/lib/aws -b /usr/local/bin/aws
  rm -rf awscli-bundle*
  EOH
  action :nothing
end

# decrypted data bag s3 credentials
aws_creds = data_bag_item('aws_s3', 'aws_s3')

# run config script
bash 'configure_awscli_script' do
  user node['aws_s3']['aws_user']
  group node['aws_s3']['aws_user']
  sensitive true
  code <<-EOH
  aws configure set aws_access_key_id \
  #{aws_creds['aws_access_key_id']}
  aws configure set aws_secret_access_key \
  #{aws_creds['aws_secret_access_key']}
  EOH
  only_if { File.exist?('/usr/local/bin/aws') }
end
