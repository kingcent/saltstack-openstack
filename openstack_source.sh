#!/bin/bash
#====================================
# $Name:         openstack_source.sh
# $Revision:     1.0
# $Function:     This a simple bash script to wget openstack grizzly source code
# $Author:       Shundong Zhao
# $organization: UnixHot
# $Create Date:  2013-08-01
#===================================
#COLOR_SUCCESS  echo -en "\\033[1;32m" 
#COLOR_FAILURE  echo -en "\\033[1;31m" 
#COLOR_WARNING  echo -en "\\033[1;33m"
#COLOR_NORMAL   echo -en "\\033[0;39m"

wget https://launchpad.net/nova/grizzly/2013.1.2/+download/nova-2013.1.2.tar.gz 
wget https://launchpad.net/glance/grizzly/2013.1.2/+download/glance-2013.1.2.tar.gz
wget https://launchpad.net/quantum/grizzly/2013.1.2/+download/quantum-2013.1.2.tar.gz
wget https://launchpad.net/keystone/grizzly/2013.1.2/+download/keystone-2013.1.2.tar.gz
wget https://launchpad.net/horizon/grizzly/2013.1.2/+download/horizon-2013.1.2.tar.gz

mv nova-2013.1.2.tar.gz ./openstack/nova/files/
mv glance-2013.1.2.tar.gz ./openstack/glance/files/
mv quantum-2013.1.2.tar.gz ./openstack/quantum/files/
mv keystone-2013.1.2.tar.gz ./openstack/keystone/files/
mv horizon-2013.1.2.tar.gz ./openstack/horizon/files/
