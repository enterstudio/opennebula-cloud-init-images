# Build base OS images for OpenNebula KVM cloud

### Requirements

Installed and configured:

* GNU make
* libvirt and QEMU/KVM
* virt-install
* disabled SELinux?
* ksvalidator (from pykickstart package)

# Quick Start

Build latest CentOS 7:

```bash
$ cd centos7
$ make build
$ make clean
```
