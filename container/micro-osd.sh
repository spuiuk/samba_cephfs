#!/bin/bash
set -eux

# usage: ./micro-osd.sh mycluster /etc/ceph/

TEST_DIR=$1
CONF_DIR=$2

# get rid of process and directories leftovers
pkill ceph-mon || true
pkill ceph-osd || true
rm -rf $TEST_DIR

# cluster wide parameters
mkdir -p ${TEST_DIR}/log
cat >> $CONF_DIR/ceph.conf <<EOF
[global]
fsid = $(uuidgen)
osd crush chooseleaf type = 0
run dir = ${TEST_DIR}/run
auth cluster required = none
auth service required = none
auth client required = none
osd pool default size = 1
EOF
export CEPH_ARGS="--conf ${CONF_DIR}/ceph.conf"

# deploy a single MON
MON_DATA=${TEST_DIR}/mon
mkdir -p $MON_DATA

cat >> $CONF_DIR/ceph.conf <<EOF
[mon.0]
log file = ${TEST_DIR}/log/mon.log
chdir = ""
mon cluster log file = ${TEST_DIR}/log/mon-cluster.log
mon data = ${MON_DATA}
mon addr = 127.0.0.1
EOF

ceph-mon --id 0 --mkfs --keyring /dev/null
touch ${MON_DATA}/keyring
ceph-mon --id 0

# deploy a single OSD
OSD_DATA=${TEST_DIR}/osd
mkdir ${OSD_DATA}

cat >> $CONF_DIR/ceph.conf <<EOF
[osd.0]
log file = ${TEST_DIR}/log/osd.log
chdir = ""
osd max object size = 2000000000
osd data = ${OSD_DATA}
osd journal = ${OSD_DATA}.journal
osd journal size = 100
osd objectstore = memstore
osd class load list = *
EOF

OSD_ID=$(ceph osd create)
ceph osd crush add osd.${OSD_ID} 1 root=default host=localhost
ceph-osd --id ${OSD_ID} --mkjournal --mkfs
ceph-osd --id ${OSD_ID}

# deploy a single MDS and MGR
MDS_DATA=${TEST_DIR}/mds
mkdir -p $MDS_DATA
ceph-mds --id a
ceph-mgr --id 0

