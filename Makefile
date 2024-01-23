run:
	podman run -it --privileged --rm --name samba_cepfs_dev \
		--env PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/bin \
		-v .:/workspaces/samba_cephfs \
		quay.io/spuiuk/samba_cephfs_dev:latest \
		/bin/bash

exec:
	podman exec -it samba_cepfs_dev /bin/bash
