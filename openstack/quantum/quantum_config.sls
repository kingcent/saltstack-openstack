/etc/quantum/api-paste.ini:
  file.managed:
    - source: salt://openstack/quantum/files/api-paste.ini
    - mode: 644
    - user: root
    - group: root

/etc/quantum/dhcp_agent.ini:
  file.managed:
    - source: salt://openstack/quantum/files/dhcp_agent.ini
    - mode: 644
    - user: root
    - group: root

/etc/quantum/l3_agent.ini:
  file.managed:
    - source: salt://openstack/quantum/files/l3_agent.ini
    - mode: 644
    - user: root
    - group: root

/etc/quantum/lbaas_agent.ini:
  file.managed:
    - source: salt://openstack/quantum/files/lbaas_agent.ini
    - mode: 644
    - user: root
    - group: root

/etc/quantum/metadata_agent.ini:
  file.managed:
    - source: salt://openstack/quantum/files/metadata_agent.ini
    - mode: 644
    - user: root
    - group: root

/etc/quantum/policy.json:
  file.managed:
    - source: salt://openstack/quantum/files/policy.json
    - mode: 644
    - user: root
    - group: root

/etc/quantum/rootwrap.conf:
  file.managed:
    - source: salt://openstack/quantum/files/rootwrap.conf
    - mode: 644
    - user: root
    - group: root

/etc/quantum/rootwrap.d/debug.filters:
  file.managed:
    - source: salt://openstack/quantum/files/rootwrap.d/debug.filters
    - mode: 644
    - user: root
    - group: root

/etc/quantum/rootwrap.d/dhcp.filters:
  file.managed:
    - source: salt://openstack/quantum/files/rootwrap.d/dhcp.filters
    - mode: 644
    - user: root
    - group: root

/etc/quantum/rootwrap.d/iptables-firewall.filters:
  file.managed:
    - source: salt://openstack/quantum/files/rootwrap.d/iptables-firewall.filters
    - mode: 644
    - user: root
    - group: root

/etc/quantum/rootwrap.d/l3.filters:
  file.managed:
    - source: salt://openstack/quantum/files/rootwrap.d/l3.filters
    - mode: 644
    - user: root
    - group: root

/etc/quantum/rootwrap.d/lbaas-haproxy.filters:
  file.managed:
    - source: salt://openstack/quantum/files/rootwrap.d/lbaas-haproxy.filters
    - mode: 644
    - user: root
    - group: root

/etc/quantum/rootwrap.d/linuxbridge-plugin.filters:
  file.managed:
    - source: salt://openstack/quantum/files/rootwrap.d/linuxbridge-plugin.filters
    - mode: 644
    - user: root
    - group: root

/etc/quantum/rootwrap.d/nec-plugin.filters:
  file.managed:
    - source: salt://openstack/quantum/files/rootwrap.d/nec-plugin.filters
    - mode: 644
    - user: root
    - group: root

/etc/quantum/rootwrap.d/openvswitch-plugin.filters:
  file.managed:
    - source: salt://openstack/quantum/files/rootwrap.d/openvswitch-plugin.filters
    - mode: 644
    - user: root
    - group: root

/etc/quantum/rootwrap.d/ryu-plugin.filters:
  file.managed:
    - source: salt://openstack/quantum/files/rootwrap.d/ryu-plugin.filters
    - mode: 644
    - user: root
    - group: root

/etc/quantum/quantum.conf:
  file.managed:
    - source: salt://openstack/quantum/files/quantum.conf
    - mode: 644
    - user: root
    - group: root
    - template: jinja
    - defaults:
      RABBITMQ_HOST: {{ pillar['quantum']['RABBITMQ_HOST'] }}
      RABBITMQ_PORT: {{ pillar['quantum']['RABBITMQ_PORT'] }}
      RABBITMQ_USER: {{ pillar['quantum']['RABBITMQ_USER'] }}
      RABBITMQ_PASS: {{ pillar['quantum']['RABBITMQ_PASS'] }}
      AUTH_KEYSTONE_HOST: {{ pillar['quantum']['AUTH_KEYSTONE_HOST'] }}
      AUTH_KEYSTONE_PORT: {{ pillar['quantum']['AUTH_KEYSTONE_PORT'] }}
      AUTH_KEYSTONE_PROTOCOL: {{ pillar['quantum']['AUTH_KEYSTONE_PROTOCOL'] }}
      AUTH_ADMIN_PASS: {{ pillar['quantum']['AUTH_ADMIN_PASS'] }}

/etc/quantum/plugins/linuxbridge/linuxbridge_conf.ini:
  file.managed:
    - source: salt://openstack/quantum/files/plugins/linuxbridge/linuxbridge_conf.ini
    - mode: 644
    - user: root
    - group: root
    - template: jinja
    - defaults:
      MYSQL_SERVER: {{ pillar['quantum']['MYSQL_SERVER'] }}
      QUANTUM_USER: {{ pillar['quantum']['QUANTUM_USER'] }}
      QUANTUM_PASS: {{ pillar['quantum']['QUANTUM_PASS'] }}
      QUANTUM_DBNAME: {{ pillar['quantum']['QUANTUM_DBNAME'] }}
      VM_INTERFACE: {{ pillar['quantum']['VM_INTERFACE'] }}

/var/log/quantum:
  file.directory:
    - user: root
    - group: root

/var/lib/quantum:
  file.directory:
    - user: root
    - group: root