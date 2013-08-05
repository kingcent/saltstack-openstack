saltstack-openstack
===================

使用Saltstack自动部署Openstack集群。

使用步骤：

1.切换到状态配置目录下 git clone https://github.com/unixhot/saltstack-openstack
2.执行./openstack_source.sh 下载源码包到各个服务/files目录下。
3.vim /etc/salt/master 增加pillar和states的设置。
4.修改top.sls
    
