My Samba-Cephfs setup. 

.devcontainer/ - Contains the settings for rootless podman. This includes the Dockerfile used to build the build container.

.vscode/ - Contains the configurations required to setup the build and debugging.

bin/ helper scripts used with the developer container


git clone the samba source repository in the root of this repository. This is where you will make changes to the samba code
```
# git clone git@gitlab.com:samba-team/samba.git 
```

To run the container, 
```
# make run
```

To attach to the running container
```
# make exec
```


Within the container, the following helper scripts are available
mycomnfigure - configures the samba sources and gets them ready to build
mymake - run make on the samba sources
myinstall - run make install on the samba sources
mysmbd - starts cephfs if not running, run mymake, myinstall and start the smbd server.
mysmbclient - run smbclient with the necessary arguments. Pass the share name to connect to.

Assuming the git repo has been cloned, this is my workflow
```
$ make run
..
[root@b3a46bdf3f64 /]# myconfigure
..
[root@b3a46bdf3f64 /]# mysmbd
..
```
At the end of this, we have smbd running based on the sources in the samba directory.

From another terminal, connect to the running samba_cephfs container.
```
$ make exec
..
# mysmbclient cephfs-vfs
Try "help" to get a list of possible commands.
smb: \> 
```
You can then perform operations to test out the vfs_cephfs module.
