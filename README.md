saltstack-openstack
===================

使用Saltstack自动部署Openstack集群。

使用步骤：

1.切换到状态配置目录下 git clone https://github.com/unixhot/saltstack-openstack
2.执行./openstack_source.sh 下载源码包。
3.vim /etc/salt/master 增加pillar和states的设置。
4.修改top.sls，配置如下：

Cluster配置:

base:
  'openstack-node1.unixhot.com':
    - openstack.keystone.keystone
    - openstack.glance.glance
    - openstack.nova.nova_control
    - openstack.quantum.quantum_server
    - openstack.quantum.quantum_linuxbridge_agent
    - openstack.horizon.horizon
    
  'openstack-node2.unixhot.com':
    - openstack.nova.nova_compute
    - openstack.quantum.quantum_linuxbridge_agent
    
  'openstack-node3.unixhot.com':
    - openstack.nova.nova_compute
    - openstack.quantum.quantum_linuxbridge_agent

ALL-IN-ONE配置:

base:
  'openstack-node1.unixhot.com':
    - openstack.keystone.keystone
    - openstack.glance.glance
    - openstack.nova.nova_control
    - openstack.quantum.quantum_server
    - openstack.quantum.quantum_linuxbridge_agent
    - openstack.horizon.horizon
    - openstack.nova.nova_compute
    
