openstack-pkg-init:
  pkg.installed:
    - names:
      - python-pip
      - gcc
      - gcc-c++
      - make
      - libtool
      - patch
      - automake
      - python-devel
      - libxslt-devel
      - MySQL-python
      - openssl-devel
      - kernel
      - kernel-devel
      - libudev-devel
      - git
      - wget
      - lvm2
      - libvirt-python
      - libvirt
      - qemu-kvm
      - scsi-target-utils
      - gedit
      - python-numdisplay
      - device-mapper
      - bridge-utils
      - httpd
      - mod_wsgi
      - dnsmasq
      - dnsmasq-utils
      - mysql-server
      - nodejs

/root/.pip/pip.conf:
  file.managed:
    - source: salt://openstack/init/files/pip.conf
    - mode: 644
    - user: root
    - group: root

mysql-server:
  pkg:
    - installed
  file.managed:
    - name: /etc/my.cnf
    - require:
      - pkg: mysql-server
  service.running:
    - name: mysqld
    - enable: True
    - require:
      - pkg: mysql-server
    - watch:
      - file: mysql-server

rabbitmq-server:
  pkg:
    - installed
  service.running:
    - name: rabbitmq-server
    - enable: True
    - require:
      - pkg: rabbitmq-server
