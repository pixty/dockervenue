#!/bin/sh -ex
# see:
# https://journal.paul.querna.org/articles/2013/10/15/docker-ubuntu-on-rackspace/

# Normally dpkg will call fsync after every package is installed, but when building an image we don't need to worry about individual fsyncs, so we can use the force-unsafe-io option:
echo 'force-unsafe-io' \
    | tee /etc/dpkg/dpkg.cfg.d/02apt-speedup
# Since we want make the image as small as possible, we add a Post-Invoke hook to dpkg which deletes cached deb files after installation:
echo 'DPkg::Post-Invoke {"/bin/rm -f /var/cache/apt/archives/*.deb || true";};' \
    | tee /etc/apt/apt.conf.d/no-cache
