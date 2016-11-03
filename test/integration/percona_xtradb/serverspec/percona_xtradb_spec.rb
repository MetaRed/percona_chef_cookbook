# encoding: utf-8
# copyright: 2015, Richard Lopez
# license: All rights reserved
# require 'spec_helper'
require_relative '../../../kitchen/data/spec_helper'

describe port(3306) do
  it { should be_listening.with('tcp') }
  it { should_not be_listening.with('udp') }
end

describe service('mysql') do
  it { should be_enabled.with_level(3) }
end

describe package('percona-xtradb-cluster-server-5.5') do
  it { should be_installed.by('apt').with_version('5.5.41-25.12-855.trusty') }
end

describe 'Percona XTRADB Cluster 5.5 config parameters' do
  context mysql_config('wsrep-provider') do
    its(:value) { should eq '/usr/lib/libgalera_smm.so' }
  end

  context mysql_config('default-storage-engine') do
    its(:value) { should eq 'InnoDB' }
  end

  context mysql_config('wsrep-sst-method') do
    its(:value) { should eq 'xtrabackup' }
  end

  context mysql_config('wsrep-cluster-name') do
    its(:value) { should eq 'Yo_Cluster_Rox' }
  end

  context mysql_config('tmp-table-size') do
    its(:value) { should eq 33_554_432 }
  end

  context mysql_config('max-heap-table-size') do
    its(:value) { should eq 33_554_432 }
  end

  context mysql_config('query-cache-type') do
    its(:value) { should eq 'OFF' }
  end

  context mysql_config('query-cache-size') do
    its(:value) { should eq 0 }
  end

  context mysql_config('max-connections') do
    its(:value) { should eq 2000 }
  end

  context mysql_config('thread-cache-size') do
    its(:value) { should eq 100 }
  end

  context mysql_config('open-files-limit') do
    its(:value) { should eq 65_535 }
  end

  context mysql_config('table-definition-cache') do
    its(:value) { should eq 4096 }
  end

  context mysql_config('table-open-cache') do
    its(:value) { should eq 4096 }
  end

  context mysql_config('log-queries-not-using-indexes') do
    its(:value) { should eq 'TRUE' }
  end

  context mysql_config('slow-query-log') do
    its(:value) { should eq 'TRUE' }
  end

  context mysql_config('slow-query-log-file') do
    its(:value) { should eq '/mysql-slow.log' }
  end

  context mysql_config('transaction-isolation') do
    its(:value) { should eq 'READ-COMMITTED' }
  end

  context mysql_config('wsrep-slave-threads') do
    its(:value) { should eq 64 }
  end
end
