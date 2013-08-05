compute-init:
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
      - qemu-kvm
      - scsi-target-utils
      - gedit
      - python-numdisplay
      - device-mapper
      - bridge-utils
      - mod_wsgi
      - dnsmasq
      - dnsmasq-utils

  file.managed:
    - name: /root/.pip/pip.conf
    - source: salt://openstack/init/files/pip.conf
    - mode: 644
    - user: root
    - group: root

messagebus:
  service.running:
    - name: messagebus
    - enable: True

libvirtd:
  file.managed:
    - name: /etc/libvirt/qemu.conf
    - source: salt://openstack/nova/files/qemu.conf
    - mode: 644
    - user: root
    - group: root
  pkg.installed:
    - names:
      - libvirt
      - libvirt-python
      - libvirt-client
  service.running:
    - name: libvirtd
    - enable: True

avahi-daemon:
  pkg.installed:
    - name: avahi
  service.running:
    - name: avahi-daemon
    - enable: True
    - require:
      - pkg: avahi-daemon
