CONTAINER_NAME := samba_cephfs:samba_dev

build:
	podman build . -t $(CONTAINER_NAME) --force-rm

push:
	podman push $(CONTAINER_NAME) quay.io/spuiuk/$(CONTAINER_NAME)

clean:
	podman rmi --force $(CONTAINER_NAME)
