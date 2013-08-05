include:
  - openstack.quantum.quantum_config
  - openstack.quantum.quantum_install

quantum-mysql:
  mysql_database.present:
    - name: {{ pillar['quantum']['QUANTUM_DBNAME'] }}
    - require:
      - service: mysql-server
  mysql_user.present:
    - name: {{ pillar['quantum']['QUANTUM_USER'] }}
    - host: {{ pillar['quantum']['HOST_ALLOW'] }}
    - password: {{ pillar['quantum']['QUANTUM_PASS'] }}
    - require:
      - mysql_database: quantum-mysql
  mysql_grants.present:
    - grant: all
    - database: {{ pillar['quantum']['DB_ALLOW'] }}
    - user: {{ pillar['quantum']['QUANTUM_USER'] }}
    - host: {{ pillar['quantum']['HOST_ALLOW'] }}
    - require:
      - mysql_user: quantum-mysql

/usr/local/bin/quantum_data.sh:
  file.managed:
    - source: salt://openstack/quantum/files/quantum_data.sh
    - mode: 755
    - user: root
    - group: root
    - template: jinja
    - defaults:
      ADMIN_PASSWD: {{ pillar['quantum']['ADMIN_PASSWD'] }} 
      ADMIN_TOKEN: {{ pillar['quantum']['ADMIN_TOKEN'] }}
      CONTROL_IP: {{ pillar['quantum']['CONTROL_IP'] }}

quantum-data-init:
  cmd.run:
    - name: bash /usr/local/bin/quantum_data.sh && touch /var/run/quantum-datainit.lock
    - require:
      - file: /usr/local/bin/quantum_data.sh
      - mysql_grants: quantum-mysql
    - unless: test -f /var/run/quantum-datainit.lock

openstack-quantum-server:
  file.managed:
    - name: /etc/init.d/openstack-quantum-server
    - source: salt://openstack/quantum/files/openstack-quantum-server
    - mode: 755
    - user: root
    - group: root
  cmd.run:
    - name: chkconfig --add openstack-quantum-server
    - unless: chkconfig --list | grep openstack-quantum-server
    - require:
      - file: openstack-quantum-server
  service.running:
    - enable: True
    - watch:
      - file: /etc/quantum/api-paste.ini
      - file: /etc/quantum/dhcp_agent.ini
      - file: /etc/quantum/l3_agent.ini
      - file: /etc/quantum/lbaas_agent.ini
      - file: /etc/quantum/metadata_agent.ini
      - file: /etc/quantum/policy.json
      - file: /etc/quantum/rootwrap.conf
      - file: /etc/quantum/rootwrap.d/debug.filters
      - file: /etc/quantum/rootwrap.d/dhcp.filters
      - file: /etc/quantum/rootwrap.d/iptables-firewall.filters
      - file: /etc/quantum/rootwrap.d/l3.filters
      - file: /etc/quantum/rootwrap.d/lbaas-haproxy.filters
      - file: /etc/quantum/rootwrap.d/linuxbridge-plugin.filters
      - file: /etc/quantum/rootwrap.d/nec-plugin.filters
      - file: /etc/quantum/rootwrap.d/openvswitch-plugin.filters
      - file: /etc/quantum/rootwrap.d/ryu-plugin.filters
      - file: /etc/quantum/quantum.conf
      - file: /etc/quantum/plugins/linuxbridge/linuxbridge_conf.ini
    - require:
      - cmd.run: quantum-install
      - cmd.run: openstack-quantum-linuxbridge-agent
      - cmd.run: quantum-data-init
      - file: /var/log/quantum
      - file: /var/lib/quantum
