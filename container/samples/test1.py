import cephfs

# Initialize the Ceph file system
fs = cephfs.LibCephFS(conffile='/etc/ceph/ceph.conf')

# Mount the Ceph file system
fs.mount()

# Create a new directory
fs.mkdir(b'/mydir', 0o777)

# Write to a file
fd = fs.open(b'/mydir/myfile', 'w')
fs.write(fd, b'hello world', 0)
fs.close(fd)

# Read from a file
fd = fs.open(b'/mydir/myfile', 'r')
print(fs.read(fd, 0, 12))
fs.close(fd)

# Get file attributes
print(fs.getxattr(b'/mydir/myfile', 'ceph.file.layout'))

# Clean up
fs.unlink(b'/mydir/myfile')
fs.rmdir(b'/mydir')

# Close the Ceph file system
fs.shutdown()
