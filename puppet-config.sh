# !/bin/bash

#sudo rpm -i http://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
#sudo yum -y update
#sudo yum -y install puppetserver

#proxies
#export https_proxy=http://10.200.208.250:3128
#export http_proxy=http://10.200.208.250:3128#
#sudo echo 'Acquire::http::proxy "http://10.200.254.23:3128";' >> /etc/apt/apt.conf

sudo apt-get remove --purge puppet* -y
sudo apt-get autoremove -y

case `lsb_release -r -s` in
16.04)
wget https://apt.puppetlabs.com/puppetlabs-release-pc1-xenial.deb
sudo dpkg -i puppetlabs-release-pc1-xenial.deb
;;

14.04)
wget https://apt.puppetlabs.com/puppetlabs-release-pc1-trusty.deb
sudo dpkg -i puppetlabs-release-pc1-trusty.deb
;;

12.04)
wget https://apt.puppetlabs.com/puppetlabs-release-pc1-precise.deb
sudo dpkg -i puppetlabs-release-pc1-precise.deb
;;

*)
echo "wos???"
;;
esac

sudo apt-get  update
sudo apt-get install puppetserver git -y

sudo cat <<EOF >> /etc/puppetlabs/puppet/puppet.conf
[master]
    certname = puppet
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

sudo /bin/sed -i "s/JAVA_ARGS=\"-Xms2g -Xmx2g -XX:MaxPermSize=256m\"/JAVA_ARGS=\"-Xms1g -Xmx1g -XX:MaxPermSize=128m\"/" /etc/default/puppetserver

sudo rm -fr /etc/puppetlabs/code/environments
sudo ln -s /vagrant/environments/ /etc/puppetlabs/code/

#sudo systemctl enable puppetserver
#sudo systemctl start puppetserver
sudo service puppetserver start

sudo /opt/puppetlabs/puppet/bin/gem install r10k

sudo mkdir -p /etc/puppetlabs/r10k
sudo cat <<EOF >> /etc/puppetlabs/r10k/r10k.yaml
# The location to use for storing cached Git repos
:cachedir: '/opt/puppetlabs/r10k/cache'

#proxy: 'http://proxy.example.com:3128'

# A list of git repositories to create
:sources:
  # This will clone the git repository and instantiate an environment per
  # branch in /etc/puppetlabs/code/environments
  :my-org:
    #remote: 'git@github.com:$_Insert GitHub Organization Here_$/$_Insert GitHub Repository That Will Be Used For Your Puppet Code Here_$'
    #remote: git@gitlab01.muctst2.elster.de:puppet/project1.git
    #remote: git@gitlab01.muctst2.elster.de:puppet/control-repo01.git
    remote: http://gitlab01.muctst2.elster.de/puppet/control-repo01.git
    basedir: '/etc/puppetlabs/code/environments'
EOF

sudo cat <<EOF >> /root/.ssh/id_rsa.pub
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCY3l4WnbECxTHs3BYCkk+1OAwmRsWrr0Z9uzFZBUt4xVZb/zOEOFlk8NByJErXFgIjdctgsTlR35OB8Szx+i6HXzfFVgX36XOkwxjRkaTNMr7TuXc8Fn41p9Eqf21aKyN7kfk+wqkGXPSvJOUkFUAq22BVtPKYAlaennqOgX3XxmEH/YQqKaeRKfZ1KjnIwWhd7SgYRNy0t5JC5cgCn3Bki3vJW5Vivn2/KujXikOgVzZyFL1cuz5ODSoxLq7CfOyvVrkOIldKNTRMADGwW/kVTtfrSbvqxituXWOj8TV84drOKefgU/RqWPSEY7Gl8UpnEIEgtOOytO/UjnefvMxX puppet@muctst2.elster.de
EOF

sudo cat <<EOF >> /etc/hosts
10.200.208.169 gitlab01.muctst2.elster.de gitlab01
EOF

sudo bash -c "ssh-keyscan -t rsa gitlab01.muctst2.elster.de >> /root/.ssh/known_hosts"

sudo /opt/puppetlabs/puppet/bin/r10k deploy environment
