# defaults
FORMAT?=qcow2
SIZE?=10
ROOT_PASSWORD:=$(shell dd if=/dev/urandom bs=1 count=64 2>/dev/null | base64 | awk "{printf \$$0}")

# Libvirt/virt-install variables
#LIBVIRT_URI?=qemu:///system
LIBVIRT_URI?=qemu:///session 

# virt-install
VI_NOREBOOT?=--noreboot
VI?=virt-install \
	--force \
	--console pty \
	--connect $(LIBVIRT_URI) \
	--name="$(VI_NAME)" \
	--ram=$(VI_RAM) \
	--vcpus=$(VI_CPU) \
	--wait=$(VI_TIMEOUT) \
	--disk path=$@.tmp,format=raw,size=$(SIZE),cache=unsafe,sparse=true,bus=virtio \
	--network=user,model=virtio \
	--video=vga \
	$(VI_NOREBOOT)
VI_NAME?=build-$(OS)-$(OS_VERSION)
VI_CPU?=2
VI_RAM?=1536
VI_TIMEOUT?=45

# qemu-image
IMAGE?=$(CURDIR)/image
QI_QCOW_OPTS?=-c -o cluster_size=2M
QI_VMDK_OPTS?=

###################################################

build: $(IMAGE).$(FORMAT)

cloud.tar: cloud/
	tar -cvf $@ $?

# convert raw->qcow2
$(IMAGE).qcow2: $(IMAGE).raw
	nice ionice -c 3 qemu-img convert $(QI_QCOW_OPTS) -O qcow2 $? $@

# convert raw->vmdk
$(IMAGE).vmdk: $(IMAGE).raw
	nice ionice -c 3 qemu-img convert $(QI_VMDK_OPTS) -O vmdk $? $@

clean: 
	-virsh -q -c $(LIBVIRT_URI) destroy  $(VI_NAME) 2>/dev/null
	-virsh -q -c $(LIBVIRT_URI) undefine $(VI_NAME) 2>/dev/null 
	rm -f $(IMAGE).raw $(IMAGE).raw.tmp $(IMAGE).$(FORMAT) \
		$(IMAGE).qcow2 $(IMAGE).vmdk cloud.tar
