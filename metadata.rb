name 'percona'
maintainer 'Richard Lopez'
maintainer_email 'code@Meta.Red'
license 'mit'
description 'Installs percona server, percona xtradb server, percona tools,
percona xtrabackup, and awscli-bundle.'

provides 'percona::server'
provides 'percona::xtradb'
provides 'percona::xtrabackup'
provides 'percona::xtradb_backup'
provides 'percona::binlog_backup'
supports 'ubuntu', '>=14.04'
chef_version '>12'

long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.0.3'

source_url 'http://github.com/metared/percona_chef_cookbook'
