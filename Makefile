# Allow developer to write custom targets
-include devel.mk

run:
	podman run -it --privileged --rm --name samba_cepfs_dev \
		--env PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/bin \
		-v .:/workspaces/samba_cephfs \
		-w /root \
		quay.io/spuiuk/samba_cephfs_dev:latest \
		/bin/bash

exec:
	podman exec -w /root -it samba_cepfs_dev /bin/bash

clean:
	-podman kill samba_cepfs_dev
	-podman rm samba_cepfs_dev

imageclean:
	podman rmi localhost/samba_cephfs_dev quay.io/spuiuk/samba_cephfs_dev quay.io/ceph/ceph --force

clonerepo:
	git clone https://github.com/samba-in-kubernetes/sit-test-cases.git
	cp -f others/test-info.yml sit-test-cases/

test:
	podman exec samba_cepfs_dev make -C /root/samba_cephfs/sit-test-cases test-nonprivileged
