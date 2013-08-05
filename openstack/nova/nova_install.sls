include:
  - openstack.init.compute

nova-install:
  file.managed:
    - name: /usr/local/src/nova-2013.1.2.tar.gz
    - source: salt://openstack/nova/files/nova-2013.1.2.tar.gz
    - mode: 644
    - user: root
    - group: root
  cmd.run:
    - name: cd /usr/local/src/ && tar zxf nova-2013.1.2.tar.gz && cd nova-2013.1.2/tools && pip-python install -r pip-requires && cd ../ && python setup.py install
    - unless: pip-python freeze | grep nova==2013.1.2
    - require:
      - pkg: compute-init
      - file: compute-init
      - file: /usr/local/src/nova-2013.1.2.tar.gz
