include:
  - openstack.init.compute

quantum-compute-install:
  file.managed:
    - name: /usr/local/src/quantum-2013.1.2.tar.gz
    - source: salt://openstack/quantum/files/quantum-2013.1.2.tar.gz
    - mode: 644
    - user: root
    - group: root
  cmd.run:
    - name: cd /usr/local/src/ && tar zxf quantum-2013.1.2.tar.gz && cd quantum-2013.1.2/tools && pip-python install -r pip-requires && cd ../ && python setup.py install
    - unless: pip-python freeze | grep quantum==2013.1.2
    - require:
      - pkg: openstack-pkg-init
      - file: /usr/local/src/quantum-2013.1.2.tar.gz
