include:
  - openstack.quantum.quantum_config
  - openstack.quantum.quantum_compute_install

openstack-quantum-linuxbridge-agent:
  file.managed:
    - name: /etc/init.d/openstack-quantum-linuxbridge-agent
    - source: salt://openstack/quantum/files/openstack-quantum-linuxbridge-agent
    - mode: 755
    - user: root
    - group: root
  cmd.run:
    - name: chkconfig --add openstack-quantum-linuxbridge-agent
    - unless: chkconfig --list | grep openstack-quantum-linuxbridge-agent
    - require:
      - file: openstack-quantum-linuxbridge-agent
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
      - file: openstack-quantum-linuxbridge-agent
    - require:
      - cmd.run: quantum-compute-install
      - cmd.run: openstack-quantum-linuxbridge-agent
      - file: /var/log/quantum
      - file: /var/lib/quantum
