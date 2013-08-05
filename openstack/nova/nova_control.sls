include:
  - openstack.nova.nova_config
  - openstack.nova.nova_install

nova-mysql:
  mysql_database.present:
    - name: {{ pillar['nova']['NOVA_DBNAME'] }}
    - require:
      - service: mysql-server
  mysql_user.present:
    - name: {{ pillar['nova']['NOVA_USER'] }}
    - host: {{ pillar['nova']['HOST_ALLOW'] }}
    - password: {{ pillar['nova']['NOVA_PASS'] }}
    - require:
      - mysql_database: nova-mysql
  mysql_grants.present:
    - grant: all
    - database: {{ pillar['nova']['DB_ALLOW'] }}
    - user: {{ pillar['nova']['NOVA_USER'] }}
    - host: {{ pillar['nova']['HOST_ALLOW'] }}
    - require:
      - mysql_user: nova-mysql

nova-init:
  cmd.run:
    - name: nova-manage db sync && touch /var/run/nova-dbsync.lock
    - require:
      - mysql_grants: nova-mysql
    - unless: test -f /var/run/nova-dbsync.lock

/usr/local/bin/nova_data.sh:
  file.managed:
    - source: salt://openstack/nova/files/nova_data.sh
    - mode: 755
    - user: root
    - group: root
    - template: jinja
    - defaults:
      ADMIN_PASSWD: {{ pillar['nova']['ADMIN_PASSWD'] }} 
      ADMIN_TOKEN: {{ pillar['nova']['ADMIN_TOKEN'] }}
      CONTROL_IP: {{ pillar['nova']['CONTROL_IP'] }}

nova-data-init:
  cmd.run:
    - name: bash /usr/local/bin/nova_data.sh && touch /var/run/nova-datainit.lock
    - require:
      - file: /usr/local/bin/nova_data.sh
      - cmd.run: nova-init
    - unless: test -f /var/run/nova-datainit.lock

nova-api-service:
  file.managed:
    - name: /etc/init.d/openstack-nova-api-os-compute
    - source: salt://openstack/nova/files/openstack-nova-api-os-compute
    - user: root
    - group: root
    - mode: 755
  cmd.run:
    - name: chkconfig --add openstack-nova-api-os-compute
    - unless: chkconfig --list | grep openstack-nova-api-os-compute
    - require:
      - file: nova-api-service
  service.running:
    - name: openstack-nova-api-os-compute
    - enable: True
    - watch:
      - file: /etc/nova/api-paste.ini
      - file: /etc/nova/logging.conf
      - file: /etc/nova/policy.json
      - file: /etc/nova/rootwrap.conf
      - file: /etc/nova/release
      - file: /etc/nova/nova.conf
      - file: /etc/nova/rootwrap.d/api-metadata.filters
      - file: /etc/nova/rootwrap.d/baremetal-compute-ipmi.filters
      - file: /etc/nova/rootwrap.d/baremetal-deploy-helper.filters
      - file: /etc/nova/rootwrap.d/compute.filters
      - file: /etc/nova/rootwrap.d/network.filters
    - require:
      - cmd.run: nova-install
      - cmd.run: nova-api-service
      - cmd.run: nova-data-init
      - file: /var/log/nova
      - file: /var/lib/nova/instances

nova-cert-service:
  file.managed:
    - name: /etc/init.d/openstack-nova-cert
    - source: salt://openstack/nova/files/openstack-nova-cert
    - user: root
    - group: root
    - mode: 755
  cmd.run:
    - name: chkconfig --add openstack-nova-cert
    - unless: chkconfig --list | grep openstack-nova-cert
    - require:
      - file: nova-cert-service
  service.running:
    - name: openstack-nova-cert
    - enable: True
    - watch:
      - file: /etc/nova/api-paste.ini
      - file: /etc/nova/logging.conf
      - file: /etc/nova/policy.json
      - file: /etc/nova/rootwrap.conf
      - file: /etc/nova/release
      - file: /etc/nova/nova.conf
      - file: /etc/nova/rootwrap.d/api-metadata.filters
      - file: /etc/nova/rootwrap.d/baremetal-compute-ipmi.filters
      - file: /etc/nova/rootwrap.d/baremetal-deploy-helper.filters
      - file: /etc/nova/rootwrap.d/compute.filters
      - file: /etc/nova/rootwrap.d/network.filters
    - require:
      - cmd.run: nova-install
      - cmd.run: nova-cert-service
      - cmd.run: nova-data-init
      - file: /var/log/nova
      - file: /var/lib/nova/instances

nova-conductor-service:
  file.managed:
    - name: /etc/init.d/openstack-nova-conductor
    - source: salt://openstack/nova/files/openstack-nova-conductor
    - user: root
    - group: root
    - mode: 755
  cmd.run:
    - name: chkconfig --add openstack-nova-conductor
    - unless: chkconfig --list | grep openstack-nova-conductor
    - require:
      - file: nova-conductor-service
  service.running:
    - name: openstack-nova-conductor
    - enable: True
    - watch:
      - file: /etc/nova/api-paste.ini
      - file: /etc/nova/logging.conf
      - file: /etc/nova/policy.json
      - file: /etc/nova/rootwrap.conf
      - file: /etc/nova/release
      - file: /etc/nova/nova.conf
      - file: /etc/nova/rootwrap.d/api-metadata.filters
      - file: /etc/nova/rootwrap.d/baremetal-compute-ipmi.filters
      - file: /etc/nova/rootwrap.d/baremetal-deploy-helper.filters
      - file: /etc/nova/rootwrap.d/compute.filters
      - file: /etc/nova/rootwrap.d/network.filters
    - require:
      - cmd.run: nova-install
      - cmd.run: nova-conductor-service
      - cmd.run: nova-data-init
      - file: /var/log/nova
      - file: /var/lib/nova/instances

nova-console-service:
  file.managed:
    - name: /etc/init.d/openstack-nova-console
    - source: salt://openstack/nova/files/openstack-nova-console
    - user: root
    - group: root
    - mode: 755
  cmd.run:
    - name: chkconfig --add openstack-nova-console
    - unless: chkconfig --list | grep openstack-nova-console
    - require:
      - file: nova-console-service
  service.running:
    - name: openstack-nova-console
    - enable: True
    - watch:
      - file: /etc/nova/api-paste.ini
      - file: /etc/nova/logging.conf
      - file: /etc/nova/policy.json
      - file: /etc/nova/rootwrap.conf
      - file: /etc/nova/release
      - file: /etc/nova/nova.conf
      - file: /etc/nova/rootwrap.d/api-metadata.filters
      - file: /etc/nova/rootwrap.d/baremetal-compute-ipmi.filters
      - file: /etc/nova/rootwrap.d/baremetal-deploy-helper.filters
      - file: /etc/nova/rootwrap.d/compute.filters
      - file: /etc/nova/rootwrap.d/network.filters
    - require:
      - cmd.run: nova-install
      - cmd.run: nova-console-service
      - cmd.run: nova-data-init
      - file: /var/log/nova
      - file: /var/lib/nova/instances

nova-consoleauth-service:
  file.managed:
    - name: /etc/init.d/openstack-nova-consoleauth
    - source: salt://openstack/nova/files/openstack-nova-consoleauth
    - user: root
    - group: root
    - mode: 755
  cmd.run:
    - name: chkconfig --add openstack-nova-consoleauth
    - unless: chkconfig --list | grep openstack-nova-consoleauth
    - require:
      - file: nova-consoleauth-service
  service.running:
    - name: openstack-nova-consoleauth
    - enable: True
    - watch:
      - file: /etc/nova/api-paste.ini
      - file: /etc/nova/logging.conf
      - file: /etc/nova/policy.json
      - file: /etc/nova/rootwrap.conf
      - file: /etc/nova/release
      - file: /etc/nova/nova.conf
      - file: /etc/nova/rootwrap.d/api-metadata.filters
      - file: /etc/nova/rootwrap.d/baremetal-compute-ipmi.filters
      - file: /etc/nova/rootwrap.d/baremetal-deploy-helper.filters
      - file: /etc/nova/rootwrap.d/compute.filters
      - file: /etc/nova/rootwrap.d/network.filters
    - require:
      - cmd.run: nova-install
      - cmd.run: nova-consoleauth-service
      - cmd.run: nova-data-init
      - file: /var/log/nova
      - file: /var/lib/nova/instances

nova-novncproxy-service:
  file.managed:
    - name: /etc/init.d/openstack-nova-novncproxy
    - source: salt://openstack/nova/files/openstack-nova-novncproxy
    - user: root
    - group: root
    - mode: 755
  cmd.run:
    - name: chkconfig --add openstack-nova-novncproxy
    - unless: chkconfig --list | grep openstack-nova-novncproxy
    - require:
      - file: nova-novncproxy-service
  service.running:
    - name: openstack-nova-novncproxy
    - enable: True
    - watch:
      - file: /etc/nova/api-paste.ini
      - file: /etc/nova/logging.conf
      - file: /etc/nova/policy.json
      - file: /etc/nova/rootwrap.conf
      - file: /etc/nova/release
      - file: /etc/nova/nova.conf
      - file: /etc/nova/rootwrap.d/api-metadata.filters
      - file: /etc/nova/rootwrap.d/baremetal-compute-ipmi.filters
      - file: /etc/nova/rootwrap.d/baremetal-deploy-helper.filters
      - file: /etc/nova/rootwrap.d/compute.filters
      - file: /etc/nova/rootwrap.d/network.filters
    - require:
      - cmd.run: nova-install
      - cmd.run: nova-novncproxy-service
      - cmd.run: nova-data-init
      - file: /var/log/nova
      - file: /var/lib/nova/instances

nova-scheduler-service:
  file.managed:
    - name: /etc/init.d/openstack-nova-scheduler
    - source: salt://openstack/nova/files/openstack-nova-scheduler
    - user: root
    - group: root
    - mode: 755
  cmd.run:
    - name: chkconfig --add openstack-nova-scheduler
    - unless: chkconfig --list | grep openstack-nova-scheduler
    - require:
      - file: nova-scheduler-service
  service.running:
    - name: openstack-nova-scheduler
    - enable: True
    - watch:
      - file: /etc/nova/api-paste.ini
      - file: /etc/nova/logging.conf
      - file: /etc/nova/policy.json
      - file: /etc/nova/rootwrap.conf
      - file: /etc/nova/release
      - file: /etc/nova/nova.conf
      - file: /etc/nova/rootwrap.d/api-metadata.filters
      - file: /etc/nova/rootwrap.d/baremetal-compute-ipmi.filters
      - file: /etc/nova/rootwrap.d/baremetal-deploy-helper.filters
      - file: /etc/nova/rootwrap.d/compute.filters
      - file: /etc/nova/rootwrap.d/network.filters
    - require:
      - cmd.run: nova-install
      - cmd.run: nova-scheduler-service
      - cmd.run: nova-data-init
      - file: /var/log/nova
      - file: /var/lib/nova/instances
