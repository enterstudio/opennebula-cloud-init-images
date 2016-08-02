# Build base OS images for OpenNebula KVM cloud

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
* Debian 8
* OpenSUSE 42.1 (*in progress*)

# Quick Start

Build latest CentOS 7:

```bash
$ cd centos-7
$ make build
$ make clean
```
