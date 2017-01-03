Percona Database Cookbook
=========================
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/4ffd7f582c8246a3ab24588e95362738)](https://www.codacy.com/app/code_6/percona_chef_cookbook?utm_source=github.com&utm_medium=referral&utm_content=MetaRed/percona_chef_cookbook&utm_campaign=badger)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Cookbook: version](https://img.shields.io/badge/Cookbook-v0.0.3-blue.svg)](https://github.com/MetaRed/percona_chef_cookbook/releases/tag/v0.0.3)
[![Build Status](https://travis-ci.org/MetaRed/percona_chef_cookbook.svg?branch=master)](https://travis-ci.org/MetaRed/percona_chef_cookbook)
[![Coverage Status](https://coveralls.io/repos/github/MetaRed/percona_chef_cookbook/badge.svg?branch=master)](https://coveralls.io/github/MetaRed/percona_chef_cookbook?branch=master)


Installs the following:

- `percona-xtradb-cluster-server`
- `percona-xtradb-cluster-client`
- `percona-server-server`
- `percona-server-client`
- `percona-xtrabackup`
- `percona-toolkit`
- `awscli-bundle`

Requirements
------------
Legacy backup scripts require the following system packages:

- `unzip`
- `pigz`
- `tar`

Attributes
----------
#### percona::server
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['version']</tt></td>
    <td>String</td>
    <td>percona server version</td>
    <td><tt>5.5</tt></td>
  </tr>
  <tr>
    <td><tt>['data_dir']</tt></td>
    <td>String</td>
    <td>database data directory</td>
    <td><tt>/data/mysql</tt></td>
  </tr>
  <tr>
    <td><tt>['bin_log_dir']</tt></td>
    <td>String</td>
    <td>binary log directory</td>
    <td><tt>/log/data/mysql</tt></td>
  </tr>
  <tr>
    <td><tt>['bin_log']</tt></td>
    <td>String</td>
    <td>binary log file</td>
    <td><tt>mysql-bin</tt></td>
  </tr>
  <tr>
    <td><tt>['relay_log']</tt></td>
    <td>String</td>
    <td>relay log file</td>
    <td><tt>mysql-relay-log</tt></td>
  </tr>
  <tr>
    <td><tt>['log_dir']</tt></td>
    <td>String</td>
    <td>info log directory</td>
    <td><tt>/var/log/mysql</tt></td>
  </tr>
  <tr>
    <td><tt>['error_log']</tt></td>
    <td>String</td>
    <td>error log file</td>
    <td><tt>mysql-error.log</tt></td>
  </tr>
  <tr>
    <td><tt>['slow_log']</tt></td>
    <td>String</td>
    <td>slow log file</td>
    <td><tt>mysql-slow.log</tt></td>
  </tr>
  <tr>
    <td><tt>['innodb_buffer_pool_size']</tt></td>
    <td>String</td>
    <td>innodb buffer pool size</td>
    <td><tt>1G</tt></td>
  </tr>
  <tr>
    <td><tt>['mysql_read_only']</tt></td>
    <td>Boolean</td>
    <td>slave read only mode</td>
    <td><tt>FALSE</tt></td>
  </tr>
  <tr>
    <td><tt>['server_sync_binlog']</tt></td>
    <td>Boolean</td>
    <td>whether to sync binary logs</td>
    <td><tt>1</tt></td>
  </tr>
  <tr>
    <td><tt>['mysql_server_id']</tt></td>
    <td>String</td>
    <td>unique db identifier</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>['query_cache_type']</tt></td>
    <td>Boolean</td>
    <td>use query caching</td>
    <td><tt>OFF</tt></td>
  </tr>
  <tr>
    <td><tt>['query_cache_size']</tt></td>
    <td>String</td>
    <td>query cache size</td>
    <td><tt>100M</tt></td>
  </tr>
  <tr>
    <td><tt>['query_cache_limit']</tt></td>
    <td>String</td>
    <td>query cache size limit</td>
    <td><tt>100M</tt></td>
  </tr>
  <tr>
    <td><tt>['log_slave_updates']</tt></td>
    <td>Boolean</td>
    <td>whether to log slave updates</td>
    <td><tt>FALSE</tt></td>
  </tr>
  <tr>
    <td><tt>['backup_email']</tt></td>
    <td>String</td>
    <td>backup email notifications</td>
    <td><tt>your@email.com</tt></td>
  </tr>
  <tr>
    <td><tt>['backup_script_dir']</tt></td>
    <td>String</td>
    <td>script file directory</td>
    <td><tt>/opt/percona_backup_scripts</tt></td>
  </tr>
  <tr>
    <td><tt>['backup_log_dir']</tt></td>
    <td>String</td>
    <td>backup script log file directory</td>
    <td><tt>/var/log/mysql/percona_backups</tt></td>
  </tr>
  <tr>
    <td><tt>['xtrabackup']['sql_dump_file']</tt></td>
    <td>String</td>
    <td>structure backup file</td>
    <td><tt>percona_structure_backup.sql</tt></td>
  </tr>
  <tr>
    <td><tt>['xtrabackup']['backup_dir']</tt></td>
    <td>String</td>
    <td>full db backup directory</td>
    <td><tt>/percona_backups</tt></td>
  </tr>
  <tr>
    <td><tt>['xtrabackup']['aws_db_bucket']</tt></td>
    <td>String</td>
    <td>aws simple storage uri</td>
    <td><tt>s3://aws-s3-link/db_bucket/</tt></td>
  </tr>
  <tr>
    <td><tt>['binlog_backup']['backup_dir']</tt></td>
    <td>String</td>
    <td>binary log backup directory</td>
    <td><tt>/percona_backups/binlog_backups</tt></td>
  </tr>
  <tr>
    <td><tt>['binlog_backup']['aws_binlog_bucket']</tt></td>
    <td>String</td>
    <td>aws simple storage binary backup uri</td>
    <td><tt>s3://aws-s3-link/bin_bucket/</tt></td>
  </tr>
</table>

#### percona::xtradb
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['version']</tt></td>
    <td>String</td>
    <td>percona xtradb version</td>
    <td><tt>5.5</tt></td>
  </tr>
  <tr>
    <td><tt>['data_dir']</tt></td>
    <td>String</td>
    <td>database data directory</td>
    <td><tt>/data/mysql</tt></td>
  </tr>
  <tr>
    <td><tt>['db_user']</tt></td>
    <td>String</td>
    <td>percona system user</td>
    <td><tt>mysql</tt></td>
  </tr>
  <tr>
    <td><tt>['binlog_format']</tt></td>
    <td>String</td>
    <td>binary log format</td>
    <td><tt>ROW</tt></td>
  </tr>
  <tr>
    <td><tt>['wsrep_provider']</tt></td>
    <td>String</td>
    <td>galera library</td>
    <td><tt>/usr/lib/libgalera_smm.so</tt></td>
  </tr>
  <tr>
    <td><tt>['default_storage_engine']</tt></td>
    <td>String</td>
    <td>database storage engine</td>
    <td><tt>InnoDB</tt></td>
  </tr>
  <tr>
    <td><tt>['innodb_locks_unsafe_for_binlog']</tt></td>
    <td>Boolean</td>
    <td>disable gap locking</td>
    <td><tt>1</tt></td>
  </tr>
  <tr>
    <td><tt>['autoinc_lock_mode']</tt></td>
    <td>String</td>
    <td>innodb increment lock mode</td>
    <td><tt>2</tt></td>
  </tr>
  <tr>
    <td><tt>['wsrep_sst_method']</tt></td>
    <td>String</td>
    <td>galera state transfer type</td>
    <td><tt>xtrabackup</tt></td>
  </tr>
  <tr>
    <td><tt>['wsrep_cluster_name']</tt></td>
    <td>String</td>
    <td>galera cluster name</td>
    <td><tt>Yo_Cluster_Rox</tt></td>
  </tr>
  <tr>
    <td><tt>['tmp_table_size']</tt></td>
    <td>String</td>
    <td>temporary table size</td>
    <td><tt>32M</tt></td>
  </tr>
  <tr>
    <td><tt>['max_heap_table_size']</tt></td>
    <td>String</td>
    <td>heap memory size limit</td>
    <td><tt>32M</tt></td>
  </tr>
  <tr>
    <td><tt>['query_cache_type']</tt></td>
    <td>String</td>
    <td>use query caching</td>
    <td><tt>OFF</tt></td>
  </tr>
  <tr>
    <td><tt>['query_cache_size']</tt></td>
    <td>String</td>
    <td>query cache size</td>
    <td><tt>0</tt></td>
  </tr>
  <tr>
    <td><tt>['max_connections']</tt></td>
    <td>String</td>
    <td>database connection limit</td>
    <td><tt>2000</tt></td>
  </tr>
  <tr>
    <td><tt>['thread_cache_size']</tt></td>
    <td>String</td>
    <td>thread cache size</td>
    <td><tt>100</tt></td>
  </tr>
  <tr>
    <td><tt>['open_files_limit']</tt></td>
    <td>String</td>
    <td>database open file limit</td>
    <td><tt>65535</tt></td>
  </tr>
  <tr>
    <td><tt>['table_definition_cache']</tt></td>
    <td>String</td>
    <td>table cache size</td>
    <td><tt>4096</tt></td>
  </tr>
  <tr>
    <td><tt>['innodb_flush_method']</tt></td>
    <td>String</td>
    <td>innodb flush method</td>
    <td><tt>O_DIRECT</tt></td>
  </tr>
  <tr>
    <td><tt>['log_files_in_group']</tt></td>
    <td>String</td>
    <td>xtradb log files in group</td>
    <td><tt>2</tt></td>
  </tr>
  <tr>
    <td><tt>['flush_log_at_trx_commit']</tt></td>
    <td>String</td>
    <td>transaction log flush setting</td>
    <td><tt>2</tt></td>
  </tr>
  <tr>
    <td><tt>['innodb_file_per_table']</tt></td>
    <td>Boolean</td>
    <td>db file per table setting</td>
    <td><tt>ON</tt></td>
  </tr>
  <tr>
    <td><tt>['buffer_pool_size']</tt></td>
    <td>String</td>
    <td>buffer pool size</td>
    <td><tt>128M</tt></td>
  </tr>
  <tr>
    <td><tt>['log_dir']</tt></td>
    <td>String</td>
    <td>info log directory</td>
    <td><tt>/var/log/mysql</tt></td>
  </tr>
  <tr>
    <td><tt>['error_log_file']</tt></td>
    <td>String</td>
    <td>error log file</td>
    <td><tt>mysql-error.log</tt></td>
  </tr>
  <tr>
    <td><tt>['log_queries_not_using_indexes']</tt></td>
    <td>Boolean</td>
    <td>log queries not using indexes</td>
    <td><tt>1</tt></td>
  </tr>
  <tr>
    <td><tt>['slow_query_log']</tt></td>
    <td>Boolean</td>
    <td>slow query log setting</td>
    <td><tt>1</tt></td>
  </tr>
  <tr>
    <td><tt>['slow_query_log_file']</tt></td>
    <td>String</td>
    <td>slow query log file</td>
    <td><tt>mysql-slow.log</tt></td>
  </tr>
  <tr>
    <td><tt>['transaction_isolation']</tt></td>
    <td>String</td>
    <td>transaction isolation level</td>
    <td><tt>READ-COMMITTED</tt></td>
  </tr>
  <tr>
    <td><tt>['innodb_read_io_threads']</tt></td>
    <td>String</td>
    <td>read io thread count</td>
    <td><tt>64</tt></td>
  </tr>
  <tr>
    <td><tt>['innodb_write_io_threads']</tt></td>
    <td>String</td>
    <td>write io thread count</td>
    <td><tt>64</tt></td>
  </tr>
  <tr>
    <td><tt>['wsrep_slave_threads']</tt></td>
    <td>String</td>
    <td>galera replication thread count</td>
    <td><tt>64</tt></td>
  </tr>
  <tr>
    <td><tt>['innodb_io_capacity']</tt></td>
    <td>String</td>
    <td>io operations limit</td>
    <td><tt>2000</tt></td>
  </tr>
  <tr>
    <td><tt>['innodb_flush_neighbor_pages']</tt></td>
    <td>String</td>
    <td>sequential page flush setting</td>
    <td><tt>cont</tt></td>
  </tr>
  <tr>
    <td><tt>['innodb_log_file_size']</tt></td>
    <td>String</td>
    <td>transaction log file size</td>
    <td><tt>4G</tt></td>
  </tr>
  <tr>
    <td><tt>['backup_log_dir']</tt></td>
    <td>String</td>
    <td>backup script log file directory</td>
    <td><tt>/var/log/mysql/percona_backups</tt></td>
  </tr>
  <tr>
    <td><tt>['backup_dir']</tt></td>
    <td>String</td>
    <td>full db backup directory</td>
    <td><tt>/percona_backups</tt></td>
  </tr>
  <tr>
    <td><tt>['backup_script_dir']</tt></td>
    <td>String</td>
    <td>script file directory</td>
    <td><tt>/opt/percona_backup_scripts</tt></td>
  </tr>
  <tr>
    <td><tt>['backup_log_dir']</tt></td>
    <td>String</td>
    <td>backup script log file directory</td>
    <td><tt>/var/log/mysql/percona_backups</tt></td>
  </tr>
  <tr>
    <td><tt>['xtradb_backup']['aws_db_bucket']</tt></td>
    <td>String</td>
    <td>aws simple storage uri</td>
    <td><tt>s3://aws-s3-link/bin_bucket/</tt></td>
  </tr>
</table>

Usage
-----
#### Recipe Groupings
`server`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[percona::server]",
    "recipe[percona::xtrabackup]",
    "recipe[percona::binlog_backup]"
  ]
}
```
`xtradb`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[percona::xtradb]",
    "recipe[percona::xtradb_backup]"
  ]
}
```
Data Bags
---------
encrypted bags: test/integration/data_bags

secret key: test/integration/keys/crypt_keyper

#### Recipe Groupings

`percona::xtrabackup`
```json
{
  "id":"mysql",
  "db_backup_user": "XXX",
  "db_backup_user_passwd": "XXX"
}
```
`percona::aws_s3`
```json
{
  "id":"aws_s3",
  "aws_access_key_id": "XXX",
  "aws_secret_access_key": "XXX"
}
```
`percona::xtradb`
```json
{
  "id":"xtradb",
  "wsrep_sst_auth": "user_name:user_password"
}
```
Testing
-------
`ChefSpec`:
```
spec/unit/recipes
```

`ServerSpec`:
```
test/integration/percona_server
test/integration/percona_xtradb
```

`Travis-CI`: Call LVM volume script from travis.yml
```yaml
before_install:
  - test/travis_ci/lvm_setup.bash 2>&1
```


Authors
-------
Authors: Richard Lopez

TODO:
-----
- :white_check_mark: Dynamic LVM2 deployment
- :white_check_mark: File system block level alignment
- [ ] Upgrade legacy scripts
- [ ] Backup ingestion
- [ ] my.cnf templates for < v5.6 support
