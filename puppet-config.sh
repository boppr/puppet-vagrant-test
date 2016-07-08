# !/bin/bash

#sudo rpm -i http://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
#sudo yum -y update
#sudo yum -y install puppetserver

#muctst2 proxies
#export https_proxy=http://10.200.208.250:3128
#export http_proxy=http://10.200.208.250:3128#
#sudo echo 'Acquire::http::proxy "http://10.200.254.23:3128";' >> /etc/apt/apt.conf

wget https://apt.puppetlabs.com/puppetlabs-release-pc1-xenial.deb
sudo dpkg -i puppetlabs-release-pc1-xenial.deb
sudo apt-get  update
sudo apt-get install puppetserver -y
sudo apt-get autoremove -y

cat <<EOF >> /etc/puppetlabs/puppet/puppet.conf
[master]
    certname = puppet.vagrant.local
    ca_name = 'Puppet CA generated on puppetmaster.vagrant.local'
    reports = files
    #reporturl = https://localhost:443/reports/upload
    #node_terminus = exec
    #external_nodes = /etc/puppetlabs/puppet-dashboard/external_node
    ssl_client_header = SSL_CLIENT_S_DN
    ssl_client_verify_header = SSL_CLIENT_VERIFY
    #storeconfigs_backend = puppetdb
    storeconfigs = false
    autosign = true
EOF

#sudo systemctl enable puppetserver
#sudo systemctl start puppetserver
#service puppetserver start

