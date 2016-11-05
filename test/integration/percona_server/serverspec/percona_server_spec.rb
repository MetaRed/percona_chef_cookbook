# encoding: utf-8
# copyright: 2015, Richard Lopez
# license: All rights reserved
# require 'spec_helper'
require_relative '../../../kitchen/data/spec_helper'

describe port(3306) do
  it { should be_listening.with('tcp') }
  it { should_not be_listening.with('udp') }
end

describe package('percona-server-server-5.5') do
  it { should be_installed.by('apt').with_version('5.5.52-rel38.3-1.trusty') }
end

describe 'Percona Server 5.5 config parameters' do
  context mysql_config('max-connect-errors') do
    its(:value) { should eq 1_000_000 }
  end

  context mysql_config('max-allowed-packet') do
    its(:value) { should eq 16_777_216 }
  end

  context mysql_config('default-storage-engine') do
    its(:value) { should eq 'InnoDB' }
  end

  context mysql_config('max-connections') do
    its(:value) { should eq 500 }
  end

  context mysql_config('thread-cache-size') do
    its(:value) { should eq 50 }
  end

  context mysql_config('slave-transaction-retries') do
    its(:value) { should eq 60 }
  end

  context mysql_config('datadir') do
    its(:value) { should eq '/data/mysql/' }
  end

  context mysql_config('log-bin') do
    its(:value) { should eq '/log/data/mysql/mysql-bin' }
  end

  context mysql_config('sync-binlog') do
    its(:value) { should eq 1 }
  end

  context mysql_config('binlog-format') do
    its(:value) { should eq 'ROW' }
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

  context mysql_config('table-definition-cache') do
    its(:value) { should eq 4096 }
  end

  context mysql_config('table-open-cache') do
    its(:value) { should eq 4096 }
  end

  context mysql_config('innodb-flush-method') do
    its(:value) { should eq 'O_DIRECT' }
  end

  context mysql_config('innodb-log-files-in-group') do
    its(:value) { should eq 2 }
  end

  context mysql_config('innodb-log-file-size') do
    its(:value) { should eq 536_870_912 }
  end

  context mysql_config('innodb-flush-log-at-trx-commit') do
    its(:value) { should eq 1 }
  end

  context mysql_config('innodb-file-per-table') do
    its(:value) { should eq 'TRUE' }
  end

  context mysql_config('innodb-buffer-pool-size') do
    its(:value) { should eq 1_073_741_824 }
  end

  context mysql_config('innodb-old-blocks-time') do
    its(:value) { should eq 1000 }
  end

  context mysql_config('innodb-buffer-pool-instances') do
    its(:value) { should eq 8 }
  end

  context mysql_config('innodb-adaptive-flushing-method') do
    its(:value) { should eq 'keep_average' }
  end

  context mysql_config('innodb-flush-neighbor-pages') do
    its(:value) { should eq 'none' }
  end

  context mysql_config('innodb-read-ahead') do
    its(:value) { should eq 'none' }
  end

  context mysql_config('log-error') do
    its(:value) { should eq '/var/log/mysql/mysql-error.log' }
  end

  context mysql_config('log-queries-not-using-indexes') do
    its(:value) { should eq 'TRUE' }
  end

  context mysql_config('slow-query-log') do
    its(:value) { should eq 'TRUE' }
  end

  context mysql_config('slow-query-log-file') do
    its(:value) { should eq '/var/log/mysql/mysql-slow.log' }
  end
end
