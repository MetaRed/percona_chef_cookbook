require 'coveralls'
require 'chefspec'
require 'chefspec/berkshelf'
ChefSpec::Coverage.start!
Coveralls.wear!
# Fake credentials for in-memory convergence
shared_context 'db-backup-credentials' do
  before do
    stub_data_bag_item('aws_s3', 'aws_s3').and_return(
      'aws_s3' => {
        'aws_access_key_id' => '12345_mock_key_id',
        'aws_secret_access_key' => '09876_mock_secret_access_key'
      }
    )
    stub_data_bag_item('mysql', 'mysql').and_return(
      'mysql' => {
        'db_backup_user' => 'mock_db_user',
        'db_backup_user_passwd' => 'mock_db_passwd'
      }
    )
  end
end

shared_context 'xtradb-credentials' do
  before do
    stub_data_bag_item('xtradb', 'xtradb').and_return(
      'xtradb' => {
        'db_backup_user' => 'mock_cluster:mock_cluster_pass'
      }
    )
  end
end
