include:
  - openstack.init.control

/usr/local/src/horizon-2013.1.2.tar.gz:
  file.managed:
    - source: salt://openstack/horizon/files/horizon-2013.1.2.tar.gz
    - mode: 644
    - user: root
    - group: root

/usr/local/src/websockify.tar.gz:
  file.managed:
    - source: salt://openstack/horizon/files/websockify.tar.gz
    - mode: 644
    - user: root
    - group: root

/usr/local/src/noVNC.tar.gz:
  file.managed:
    - source: salt://openstack/horizon/files/noVNC.tar.gz
    - mode: 644
    - user: root
    - group: root

novnc-install:
  cmd.run:
    - name: cd /usr/local/src/ && tar zxf noVNC.tar.gz && cp -r noVNC/ /usr/share/novnc
    - unless: test -d /usr/share/novnc
    - require:
      - file: /usr/local/src/noVNC.tar.gz

websockify-install:
  cmd.run:
    - name: cd /usr/local/src && tar zxf websockify.tar.gz && cd websockify && python setup.py install
    - unless: pip-python freeze | grep websockify
    - require:
      - file: /usr/local/src/websockify.tar.gz

horizon-install:
  cmd.run:
    - name: cd /usr/local/src/ && tar zxf horizon-2013.1.2.tar.gz && cd horizon-2013.1.2/tools && pip-python install -r pip-requires && cd ../ && python setup.py install
    - unless: pip-python freeze | grep horizon==2013.1.2
    - require:
      - pkg: openstack-pkg-init
      - file: /usr/local/src/horizon-2013.1.2.tar.gz

horizon-init:
  cmd.run:
    - name: mv /usr/local/src/horizon-2013.1.2 /var/www/ && chown -R apache:apache /var/www/horizon-2013.1.2
    - require:
      - cmd.run : horizon-install
    - unless: test -d /var/www/horizon-2013.1.2

openstack_dashboard:
  file.managed:
    - name: /var/www/horizon-2013.1.2/openstack_dashboard/local/local_settings.py
    - source: salt://openstack/horizon/files/local_settings.py
    - user: apache
    - group: apache
    - template: jinja
    - defaults:
      CONTROL_IP: {{ pillar['horizon']['CONTROL_IP'] }}
    - require:
      - pkg: httpd

/etc/httpd/conf.d/horzion.conf:
  file.managed:
    - source: salt://openstack/horizon/files/horizon.conf
    - user: apache
    - group: apache

httpd:
  pkg:
    - installed
  service:
    - running
    - watch:
      - pkg: httpd
    - require:
      - file: /etc/httpd/conf.d/horzion.conf
      - file: openstack_dashboard
