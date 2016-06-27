# !/bin/bash

#sudo rpm -ih http://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm
sudo rpm -i http://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
sudo yum -y update
sudo yum -y install puppetserver


cat <<EOF >> /etc/puppetlabs/puppet/puppet.conf
[master]
    certname = puppetmaster01.example.com
    dns_alt_names = puppetmaster01,puppetmaster01.example.com,puppet,puppet.example.com
    ca_name = 'Puppet CA generated on puppetmaster01.example.com at 2013-08-09 19:11:11 +0000'
    reports = http,puppetdb
    reporturl = https://localhost:443/reports/upload
    node_terminus = exec
    external_nodes = /etc/puppetlabs/puppet-dashboard/external_node
    ssl_client_header = SSL_CLIENT_S_DN
    ssl_client_verify_header = SSL_CLIENT_VERIFY
    storeconfigs_backend = puppetdb
    storeconfigs = true
    autosign = true
EOF

sudo systemctl enable puppetserver
sudo systemctl start puppetserver
