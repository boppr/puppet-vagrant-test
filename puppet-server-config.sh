# !/bin/bash
echo 'server script'

sudo apt-get remove --purge 'puppet*' -y
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

sudo /bin/sed -i "s/JAVA_ARGS=\"-Xms2g -Xmx2g -XX:MaxPermSize=256m\"/JAVA_ARGS=\"-Xms1g -Xmx1g -XX:MaxPermSize=128m\"/" /etc/default/puppetserver

sudo rm -fr /etc/puppetlabs/code/environments
sudo rm -fr /vagrant/environments/*
sudo ln -s /vagrant/environments/ /etc/puppetlabs/code/

sudo service puppetserver start

sudo /opt/puppetlabs/puppet/bin/gem install r10k

sudo mkdir -p /etc/puppetlabs/r10k
sudo cat <<EOF > /etc/puppetlabs/r10k/r10k.yaml
# The location to use for storing cached Git repos
:cachedir: '/opt/puppetlabs/r10k/cache'

#proxy: 'http://proxy.example.com:3128'
private_key: '/root/.ssh/id_rsa'
# A list of git repositories to create
:sources:
  # This will clone the git repository and instantiate an environment per
  # branch in /etc/puppetlabs/code/environments
  :my-org:
    #remote: 'git@github.com:$_Insert GitHub Organization Here_$/$_Insert GitHub Repository That Will Be Used For Your Puppet Code Here_$'
    #remote: git@gitlab01.muctst2.elster.de:puppet/project1.git
    #remote: git@gitlab01.muctst2.elster.de:puppet/control-repo01.git
    #remote: http://gitlab01.muctst2.elster.de/puppet/control-repo01.git
    remote: https://github.com/boppr/control-repo01.git
    basedir: '/etc/puppetlabs/code/environments'
EOF

sudo cat <<EOF > /root/.ssh/id_rsa.pub
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCY3l4WnbECxTHs3BYCkk+1OAwmRsWrr0Z9uzFZBUt4xVZb/zOEOFlk8NByJErXFgIjdctgsTlR35OB8Szx+i6HXzfFVgX36XOkwxjRkaTNMr7TuXc8Fn41p9Eqf21aKyN7kfk+wqkGXPSvJOUkFUAq22BVtPKYAlaennqOgX3XxmEH/YQqKaeRKfZ1KjnIwWhd7SgYRNy0t5JC5cgCn3Bki3vJW5Vivn2/KujXikOgVzZyFL1cuz5ODSoxLq7CfOyvVrkOIldKNTRMADGwW/kVTtfrSbvqxituXWOj8TV84drOKefgU/RqWPSEY7Gl8UpnEIEgtOOytO/UjnefvMxX puppet@muctst2.elster.de
EOF

sudo cat <<EOF > /root/.ssh/id_rsa
-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAmN5eFp2xAsUx7NwWApJPtTgMJkbFq69GfbsxWQVLeMVWW/8z
hDhZZPDQciRK1xYCI3XLYLE5Ud+TgfEs8fouh183xVYF9+lzpMMY0ZGkzTK+07l3
PBZ+NafRKn9tWisje5H5PsKpBlz0ryTlJBVAKttgVbTymAJWnp56joF918ZhB/2E
KimnkSn2dSo5yMFoXe0oGETctLeSQuXIAp9wZIt7yVuVYr59vyro14pDoFc2chS9
XLs+Tg0qMS6uwnzsr1a5DiJXSjU0TAAxsFv5FU7X60m76sYrbl1jo/E1fOHazinn
4FP0alj0hGOxpfFKZxCBILTjsrTv1I53n7zMVwIDAQABAoIBACqPTlaxlISW7i1p
oN8aaQKlFgzaC1KfO9rpcPW92aNIHaEDTg5zub+2o/IDVKrJP9MrinHjJXg77M9y
m/bKloWt5tMT/hllb4LhpllCWUWf6Sz9J8sc4AqELGHOlF1UQU6391KX04MoAh95
ACqpl/HWnd1+wUO88uy6ZpiiSKz36gf5lEspwSB6Hxu9xF+nIRyAztHHRkN9nrHs
f/OIcoZR08dNyR7g3GrIhTpY+0dc3JtQv1W0kTQV1rp9gfxYT/2PG6IQjiKEmvmB
vkHCNh6qrQaJqeVjli+0Brbhau8kcKcxZJg3n9YySk3wgcjlDQuVOLDO/6g60pX3
dSHStvECgYEAxy0ab2Ghkp5jUMQ6TfrZuz7vyxcU/35Km6A3pxDSf8vykP8+jrwJ
g7UZehJltz0POL1kaL9tqbw6Y5JdsM0wbDMyUr/WlUXKNMMP6HjKZmGmo/mLylM/
qPlrfMZyXRqov6A44axpwt1Pz2uajjU4RE8kpKGUJ1dYHK8/+8r9c+sCgYEAxHst
NuUf/+1tR2iHFXR0I3y+ETtbIiz4ggVFA57RmN3nJlGnY3etU3JNJW9F+WZWf7zd
FB/Cf1/cOJI94861+nCJoHWw29F6GiKXHJQ/VABWIQOimzSeK8IqaSOzviOLL/Mg
B3/Crth2NfVOJrQrZquaMzuIjgLS1nIjB6s4KkUCgYBa0Mvu4TtEmQd7uh1DlQ9V
+zpnBZ1DaZgnIYR+noL8VkfBqUAi4MYN0bNOH7lVNXgNTP3NbQtZi0OsRv6FMOnV
S/q0FFiJM4shR5enTfwrdnb+6Te+BvtN1nwWJn3ayd8LkMiezXhjq3lKgCu2j7ma
G+P/VNUyovbADYBFFKdABQKBgQDCuvX39yQ86VqqMD3ZlL5aQZK6z2ImP/3YF1Ls
IKbI4/zo7HqCyaT+FEXDeUIXyUaneU5/WG7TAPXpF3/BXSjc2lZ8ssgjRLzIVEoC
KCePoHm8ZLbvLjopUlnoNFs7ckzLrCGtbQFNevnFxqa7E0wEiMTeS/2uCbxej2aK
fja/JQKBgGSqnB6B8/0g6a8qP8KTpxm5Bkj9zbipNACfQykKN7CmG+KJ4LxfQkjW
tXhECwSqnmPfhZPK33QmYzTlPDZCZ48B+xuL+Of9gMoFIXP3d3YYMhBu6RmWKLeA
WbCRitTddxbZmtgPT/CGp5JkraoPbkS7XEbYc4qjlRDiLwjw57sL
-----END RSA PRIVATE KEY-----
EOF

sudo chmod 0600 /root/.ssh/id_rsa

sudo cat <<EOF >> /etc/hosts
10.200.208.169 gitlab01.muctst2.elster.de gitlab01
EOF

sudo bash -c "ssh-keyscan -t rsa gitlab01.muctst2.elster.de >> /root/.ssh/known_hosts"

sudo rm -fr /opt/puppetlabs/r10k/cache/*

sudo /opt/puppetlabs/puppet/bin/r10k deploy environment

[ -e /usr/bin/puppet ] || sudo ln -s /opt/puppetlabs/bin/puppet /usr/bin/puppet
[ -e /usr/bin/r10k ] || sudo ln -s /opt/puppetlabs/puppet/bin/r10k /usr/bin/r10k
