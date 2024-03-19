#!/bin/bash -x

if ! [ -d /config ]
then
	echo "Config volume not set"
	exit
fi

rm -rf /etc/ceph /config/ceph
mkdir /config/ceph
ln -s /config/ceph /etc/ceph

cd /
sh /micro-osd.sh mycluster

cp -f /mycluster/ceph.conf /etc/ceph/ceph.conf

# Create subvolume and wait for it to be ready
ceph fs subvolume create cephfs samba  --mode 0777
while ! ceph fs subvolume info cephfs samba|grep '"state": "complete"'
do
	sleep 1
done

VOLPATH=$(ceph fs subvolume getpath cephfs samba)
cat >/config/ceph/cephfs-samba.conf <<EOF
[cephfs-vfs]
path = ${VOLPATH}
vfs objects = ceph
ceph: config_file = /etc/ceph/ceph.conf
ceph: user_id = samba.gw
read only = no
oplocks = no
kernel share modes = no
EOF


while :
do
	sleep 1000
done
