/bin/sh rm /etc/ceph/ceph/* && \
	sh /micro-osd.sh /mycluster /etc/ceph && \
        ceph osd pool create cephfs_data 64 && \
        ceph osd pool create cephfs_metadata 64 && \
        ceph fs new cephfs cephfs_metadata cephfs_data

sleep 2
mkdir /mnt-cephfs
ceph-fuse -m 127.0.0.1:6789 /mnt-cephfs

# Make cephfs root writable for all
chmod 0777 /mnt-cephfs

#ceph auth get-or-create client.samba.gw mon 'allow r' osd 'allow *' mds 'allow *' -o /etc/ceph/ceph.client.samba.gw.keyring
