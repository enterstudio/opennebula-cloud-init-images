# Build base OS images for OpenNebula KVM cloud

These tools help with building base OS images with
[cloud-init](http://cloudinit.readthedocs.io/)
contextualization for the OpenNebula KVM cloud. Significant work has
been done for [CERIT Scientific Cloud](http://www.cerit-sc.cz/),
later forked and extended for more systems (openSUSE, Fedora etc.)

### Requirements

Installed and configured:

* GNU make
* libvirt and QEMU/KVM
* virt-install
* disabled SELinux?
* ksvalidator (from pykickstart package)
* xmllint

# Supported systems

* CentOS 6, 7
* Fedora 24
* Debian 8
* OpenSUSE 42.1

# Quick Start

Build latest CentOS 7:

```bash
$ cd centos-7
$ make build
$ make clean
```
