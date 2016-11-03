# # encoding: utf-8

# Inspec test for recipe percona::server

# The Inspec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec_reference.html

unless os.windows?
  describe user('root') do
    it { should exist }
    skip 'This is an example test, replace with your own test.'
  end
end

describe port(80) do
  it { should_not be_listening }
  skip 'This is an example test, replace with your own test.'
end

# Check service
describe service('mysql') do
  it { should be_enabled }
  it { should be_installed }
  it { should be_running }
end

# Check port status
describe port(3306) do
  it { should be_listening }
  its('protocols') { should eq ['tcp'] }
end

control 'mysql-cnf' do                            # A unique ID for this control
  title 'Percona Configuration File'              # Readable by a human
  desc 'Verify MySql file integrity.'             # Optional description
  describe file('/etc/mysql/my.cnf') do           # The actual test
    it { should be_owned_by 'root' }
    it { should exist }
    it { should be_file }
    it { should be_readable.by('owner') }
  end
end

control 'mysql-data-dir' do                       # A unique ID for this control
  title 'Percona Data Directory'                  # Readable by a human
  desc 'Verify MySql data directory integrity.'   # Optional description
  describe file('/data/mysql') do                 # The actual test
    it { should be_owned_by 'mysql' }
    it { should exist }
    it { should be_directory }
    it { should be_readable.by('owner') }
  end
end

control 'mysql-binlog-dir' do                     # A unique ID for this control
  title 'Percona bin-log directory'               # Readable by a human
  desc 'Verify MySql binlog directory integrity.' # Optional description
  describe file('/log/data/mysql') do             # The actual test
    it { should be_owned_by 'mysql' }
    it { should exist }
    it { should be_directory }
    it { should be_readable.by('owner') }
  end
end

control 'mysql-logfile-dir' do # A unique ID for this control
  title 'Percona log file directory'                # Readable by a human
  desc 'Verify MySql log file directory integrity.' # Optional description
  describe file('/var/log/mysql') do                # The actual test
    it { should be_owned_by 'mysql' }
    it { should exist }
    it { should be_directory }
    it { should be_readable.by('owner') }
  end
end

# Check my.cnf contents
describe mysql_conf('/etc/mysql/my.cnf') do
  its('max_connect_errors') { should eq '1000000' }
  its('user') { should eq 'mysql' }
  its('max_allowed_packet') { should eq '16M' }
  its('max_connect_errors') { should eq '1000000' }
  its('default_storage_engine') { should eq 'InnoDB' }
  its('max_connections') { should eq '500' }
  its('thread_cache_size') { should eq '50' }
  its('slave_transaction_retries') { should eq '60' }
  its('datadir') { should eq '/data/mysql' }
  its('log_bin') { should eq '/log/data/mysql/mysql-bin' }
  its('sync_binlog') { should eq '1' }
  its('binlog_format') { should eq 'ROW' }
  its('tmp_table_size') { should eq '32M' }
  its('max_heap_table_size') { should eq '32M' }
  its('query_cache_type') { should eq '0' }
  its('query_cache_size') { should eq '0' }
  its('max_connections') { should eq '500' }
  its('thread_cache_size') { should eq '50' }
  its('open_files_limit') { should eq '65535' }
  its('table_definition_cache') { should eq '4096' }
  its('table_open_cache') { should eq '4096' }
  its('innodb_flush_method') { should eq 'O_DIRECT' }
  its('innodb_log_files_in_group') { should eq '2' }
  its('innodb_log_file_size') { should eq '512M' }
  its('innodb_flush_log_at_trx_commit') { should eq '1' }
  its('innodb_file_per_table') { should eq '1' }
  its('innodb_buffer_pool_size') { should eq '30G' }
  its('innodb_old_blocks_time') { should eq '1000' }
  its('innodb_buffer_pool_instances') { should eq '8' }
  its('innodb_adaptive_flushing_method') { should eq 'keep_average' }
  its('innodb_flush_neighbor_pages') { should match 'none' }
  its('innodb_read_ahead') { should eq 'none' }
  its('log_error') { should eq '/var/log/mysql/mysql-error.log' }
  its('log_queries_not_using_indexes') { should eq '1' }
  its('slow_query_log') { should eq '1' }
  its('slow_query_log_file') { should eq '/var/log/mysql/mysql-slow.log' }
end
