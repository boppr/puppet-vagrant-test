#!/bin/bash

clear
echo 'please enter a name'
read modname
echo 'is this ok? (y/n)'
echo $USER-$modname
read answer
if echo $answer | grep  [yY];
then
    echo 'continue!'
else
    echo 'abort'
    exit 1
fi

vagrant up
vagrant ssh puppet -c "puppet module generate $USER-$modname"
vagrant ssh puppet -c "mv $modname /vagrant/environments/development/modules/"
vagrant ssh puppet -c "ln -s /vagrant/environments/development/modules/$modname /vagrant/$modname"
vagrant ssh puppet -c "/bin/sed -i \"s/#spaceholder/include $modname/\" /vagrant/environments/development/site/profile/manifests/puppetclient.pp"

