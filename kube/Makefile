play:
	podman kube play samba_cephfs.yaml

down:
	podman kube down samba_cephfs.yaml

build_images:
	make -C containers/cephfs build
	make -C containers/samba_dev build

push_images:
	make -C containers/cephfs push
	make -C containers/samba_dev push

clean_images:
	-podman rmi localhost/samba_cephfs:samba_dev localhost/samba_cephfs:cephfs
	-podman rmi quay.io/spuiuk/samba_cephfs:samba_dev quay.io/spuiuk/samba_cephfs:cephfs

samba_dev:
	podman exec -w /root -it samba-cephfs-samba_dev bash

cephfs:
	podman exec -it samba-cephfs-cephfs bash

restart_cephfs:
	podman restart  samba-cephfs-cephfs

tcpdump:
	-podman exec -it samba-cephfs-samba_dev dnf install -y tcpdump
	podman exec -it samba-cephfs-samba_dev tcpdump -i lo -w /config/out.pcap -s0
	wireshark /tmp/samba_cephfs_config/out.pcap
