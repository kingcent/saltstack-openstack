include:
  - openstack.init.control

keystone-install:
  file.managed:
    - name: /usr/local/src/keystone-2013.1.2.tar.gz
    - source: salt://openstack/keystone/files/keystone-2013.1.2.tar.gz
    - mode: 644
    - user: root
    - group: root
  cmd.run:
    - name: cd /usr/local/src/ && tar zxf keystone-2013.1.2.tar.gz && cd keystone-2013.1.2/tools && pip-python install -r pip-requires && cd ../ && python setup.py install
    - unless: pip-python freeze | grep keystone==2013.1.2
    - require: 
      - pkg: openstack-pkg-init
      - file: keystone-install

/etc/keystone/logging.conf:
  file.managed:
    - source: salt://openstack/keystone/files/logging.conf
    - mode: 644
    - user: root
    - group: root

/etc/keystone/default_catalog:
  file.managed:
    - source: salt://openstack/keystone/files/default_catalog
    - mode: 644
    - user: root
    - group: root

/etc/keystone/policy.json:
  file.managed:
    - source: salt://openstack/keystone/files/policy.json
    - mode: 644
    - user: root
    - group: root

/etc/keystone/keystone.conf:
  file.managed:
    - source: salt://openstack/keystone/files/keystone.conf
    - mode: 644
    - user: root
    - group: root
    - template: jinja
    - defaults:
      MYSQL_SERVER: {{ pillar['keystone']['MYSQL_SERVER'] }}
      KEYSTONE_PASS: {{ pillar['keystone']['KEYSTONE_PASS'] }}
      KEYSTONE_USER: {{ pillar['keystone']['KEYSTONE_USER'] }}
      KEYSTONE_DBNAME: {{ pillar['keystone']['KEYSTONE_DBNAME'] }}
      ADMIN_TOKEN: {{ pillar['keystone']['ADMIN_TOKEN'] }}

/var/log/keystone:
  file.directory:
    - user: root
    - group: root

keystone-mysql:
  mysql_database.present:
    - name: {{ pillar['keystone']['KEYSTONE_DBNAME'] }}
    - require:
      - service: mysql-server
  mysql_user.present:
    - name: {{ pillar['keystone']['KEYSTONE_USER'] }}
    - host: {{ pillar['keystone']['HOST_ALLOW'] }}
    - password: {{ pillar['keystone']['KEYSTONE_PASS'] }}
    - require:
      - mysql_database: keystone-mysql
  mysql_grants.present:
    - grant: all
    - database: {{ pillar['keystone']['DB_ALLOW'] }}
    - user: {{ pillar['keystone']['KEYSTONE_USER'] }}
    - host: {{ pillar['keystone']['HOST_ALLOW'] }}
    - require:
      - mysql_user: keystone-mysql

keystone-init:
  cmd.run:
    - name: keystone-manage db_sync && touch /var/run/keystone-dbsync.lock
    - require:
      - mysql_grants: keystone-mysql
    - unless: test -f /var/run/keystone-dbsync.lock

openstack-keystone:
  file.managed:
    - name: /etc/init.d/openstack-keystone
    - source: salt://openstack/keystone/files/openstack-keystone
    - mode: 755
    - user: root
    - group: root
  cmd.run:
    - name: chkconfig --add openstack-keystone
    - unless: chkconfig --list | grep keystone
    - require:
      - file: openstack-keystone
  service.running:
    - enable: True
    - watch:
      - file: /etc/keystone/logging.conf
      - file: /etc/keystone/default_catalog
      - file: /etc/keystone/policy.json
      - file: /etc/keystone/keystone.conf
    - require:
      - cmd.run: keystone-install
      - cmd.run: keystone-init
      - cmd.run: openstack-keystone
      - file: /var/log/keystone

keystone-data-init:
  file.managed:
    - name: /usr/local/bin/keystone_data.sh
    - source: salt://openstack/keystone/files/keystone_data.sh
    - mode: 755
    - user: root
    - group: root
    - template: jinja
    - defaults:
      ADMIN_PASSWD: {{ pillar['keystone']['ADMIN_PASSWD'] }} 
      ADMIN_TOKEN: {{ pillar['keystone']['ADMIN_TOKEN'] }}
      USER_PASSWD: {{ pillar['keystone']['USER_PASSWD'] }}
      CONTROL_IP: {{ pillar['keystone']['CONTROL_IP'] }}
  cmd.run:
    - name: bash /usr/local/bin/keystone_data.sh && touch /var/run/keystone-datainit.lock
    - require:
      - file: keystone-data-init
      - service: openstack-keystone
    - unless: test -f /var/run/keystone-datainit.lock

/root/keystone_admin:
  file.managed:
    - source: salt://openstack/keystone/files/keystone_admin
    - mode: 755
    - user: root
    - group: root
    - template: jinja
    - defaults:
      ADMIN_PASSWD: {{ pillar['keystone']['ADMIN_PASSWD'] }}
      ADMIN_TOKEN: {{ pillar['keystone']['ADMIN_TOKEN'] }}
      CONTROL_IP: {{ pillar['keystone']['CONTROL_IP'] }}
