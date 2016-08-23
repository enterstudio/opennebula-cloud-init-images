# Based on
# https://git.fedorahosted.org/cgit/spin-kickstarts.git/tree/fedora-cloud-base.ks

#text
install
lang en_US.UTF-8
keyboard us
timezone --utc --ntpservers=ntp.muni.cz,tik.cesnet.cz,tak.cesnet.cz Europe/Prague
firstboot --disable
#network --device=eth0 --bootproto dhcp --onboot=yes
skipx
cmdline
poweroff

# security
rootpw --iscrypted *
authconfig --enableshadow --passalgo=sha512
firewall --disabled
selinux --permissive
services --enabled=network,sshd,cloud-init,cloud-init-local,cloud-config,cloud-final

# Partitioning, bootloader
zerombr
clearpart --all --initlabel
part / --fstype=ext4 --grow --label=root --fsoptions="defaults,usrjquota=aquota.user,grpjquota=aquota.group,jqfmt=vfsv0"
bootloader --location=mbr --append="elevator=deadline console=tty0 console=ttyS0,115200"

# Install repositories
repo --name=updates

%packages
@Development Tools
-NetworkManager
cloud-init
cloud-utils-growpart
quota
%end

%post --nochroot --erroronfail --log=/dev/console
set -e
install -Dp --mode=644 /cloud.cfg /mnt/sysimage/etc/cloud/cloud.cfg
quotacheck -vcguma
chroot /mnt/sysimage restorecon -Fi aquota.user aquota.group
quotaon -a
%end

%post --erroronfail --log=/dev/console
set -e

# network fixes
unlink /etc/hostname
unlink /etc/sysconfig/network-scripts/ifcfg-ens3

cat > /etc/sysconfig/network << EOF
NETWORKING=yes
NOZEROCONF=yes
DEVTIMEOUT=10
EOF

cat > /etc/sysconfig/network-scripts/ifcfg-eth0 << EOF
DEVICE="eth0"
BOOTPROTO="dhcp"
ONBOOT="yes"
TYPE="Ethernet"
PERSISTENT_DHCLIENT="yes"
EOF

dnf clean all

# https://bugzilla.redhat.com/show_bug.cgi?id=756130
set +e
unlink /etc/udev/rules.d/80-net-setup-link.rules
ln -s /dev/null /etc/udev/rules.d/80-net-setup-link.rules
unlink /etc/udev/rules.d/70-persistent-net.rules
ln -s /dev/null /etc/udev/rules.d/70-persistent-net.rules
unlink /etc/udev/rules.d/70-persistent-cd.rules
ln -s /dev/null /etc/udev/rules.d/70-persistent-cd.rules
%end
