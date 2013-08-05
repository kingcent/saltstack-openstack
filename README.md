saltstack-openstack
===================

Auto Deploy Openstack IAAS With Saltstack.

1.Pillar设置：

本案例大量的配置文件使用Pillar变量，实际使用中，仅需要更改pillar下的一些诸如IP地址、用户名、密码的修改即可。每个服务均有一个独立的pillar的sls。

[root@unixhot pillar]# tree
|-- openstack
|   |-- glance.sls
|   |-- horizon.sls
|   |-- keystone.sls
|   |-- nova.sls
|   `-- quantum.sls
`-- top.sls

2.SLS设置：

    每一个服务均有一个对应的目录用于存放sls和files。其中init目录存放用于进行系统初始化的sls。分为控制节点和计算节点。除了nova和quantum区分控制节点和计算节点外，其它的SLS默认均安装在一个控制节点上。
[root@unixhot openstack]# tree -L 2
|-- glance
|   |-- files
|   `-- glance.sls
|-- horizon
|   |-- files
|   `-- horizon.sls
|-- init
|   |-- compute.sls
|   |-- control.sls
|   `-- files
|-- keystone
|   |-- files
|   `-- keystone.sls
|-- nova
|   |-- files
|   |-- nova_compute.sls
|   |-- nova_config.sls
|   |-- nova_control.sls
|   `-- nova_install.sls
`-- quantum
    |-- files
    |-- quantum_config.sls
    |-- quantum_install.sls
    |-- quantum_linuxbridge_agent.sls
`-- quantum_server.sls

3.使用步骤：

1.安装Salt Master和Minion。
2.git clone https://github.com/unixhot/saltstack-openstack
