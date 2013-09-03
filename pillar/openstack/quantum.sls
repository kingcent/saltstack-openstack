quantum:
  MYSQL_SERVER: 10.1.1.11
  QUANTUM_DBNAME: quantum
  QUANTUM_USER: quantum
  QUANTUM_PASS: quantum
  DB_ALLOW: quantum.*
  HOST_ALLOW: 10.1.1.0/255.255.255.0 
  RABBITMQ_HOST: 10.1.1.11
  RABBITMQ_PORT: 5672
  RABBITMQ_USER: guest
  RABBITMQ_PASS: unixhot
  AUTH_KEYSTONE_HOST: 10.1.1.11 
  AUTH_KEYSTONE_PORT: 35357
  AUTH_KEYSTONE_PROTOCOL: http
  AUTH_ADMIN_PASS: unixhot
  ADMIN_PASSWD: unixhot
  ADMIN_TOKEN: aa160a08kjsldf386d58
  CONTROL_IP: 10.1.1.11
  {% if grains['fqdn'] == 'openstack-node1.unixhot.com' or grains['fqdn'] == 'openstack-node2.unixhot.com' %}
  VM_INTERFACE: eth2
  {% elif grains['fqdn'] == 'openstack-node3.unixhot.com' %}
  VM_INTERFACE: eth1
  {% else %}
  VM_INTERFACE: em1
  {% endif %}
