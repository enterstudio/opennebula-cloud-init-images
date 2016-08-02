OS=OpenSUSE
OS_VERSION=42.1

include ../common.mk

.PHONY: FORCE

FORCE:

%.xml:
	xmllint --noout $@

$(IMAGE).raw: autoinst.xml cloud.cfg
	rm -f $@.tmp
	$(VI) --nographics \
		--os-variant=opensuse-unknown \
		$(patsubst %,--initrd-inject=%, $?) \
		--location http://download.opensuse.org/distribution/leap/${OS_VERSION}/repo/oss/ \
		-x "elevator=deadline console=tty0 console=ttyS0,115200 serial autoyast=file:///autoinst.xml" && echo OK
	mv $@.tmp $@


