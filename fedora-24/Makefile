OS=Fedora
OS_VERSION=24

include ../common.mk

.PHONY: FORCE

FORCE:

%.ks:
	ksvalidator -v F23 $@

$(IMAGE).raw: fedora.ks cloud.cfg
	rm -f $@.tmp
	$(VI) --nographics \
		--os-variant=fedora22 \
		$(patsubst %,--initrd-inject=%, $?) \
		--location http://ftp.linux.cz/pub/linux/fedora-releases/24/Everything/x86_64/os/ \
		-x "elevator=deadline console=tty0 console=ttyS0,115200 inst.ks=file:/fedora.ks inst.cmdline noshell" && echo OK
	mv $@.tmp $@

