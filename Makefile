# Allow developer to write custom targets
-include devel.mk

start:
	make -C ./kube/ play

stop:
	make -C ./kube/ down

exec:
	make -C ./kube/ samba_dev

clean_images:
	make -C ./kube/ clean_images

clonerepo:
	git clone https://github.com/samba-in-kubernetes/sit-test-cases.git
	cp -f others/test-info.yml sit-test-cases/

tcpdump:
	make -C ./kube/ tcpdump
