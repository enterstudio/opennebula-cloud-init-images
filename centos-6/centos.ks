# Documentnation for RHEL6 Kickstart:
# http://docs.redhat.com/docs/en-US/Red_Hat_Enterprise_Linux/6/html/Installation_Guide/s1-kickstart2-options.html
text
install
lang en_US.UTF-8
keyboard us
timezone --utc Etc/UTC
firstboot --disable
network --device=eth0 --bootproto dhcp --onboot=yes
skipx
cmdline
poweroff

# security
rootpw      --lock --iscrypted *
authconfig	--enableshadow --passalgo=sha512
firewall    --disabled
selinux     --permissive

# Partitioning, bootloader
zerombr
clearpart --all --initlabel
#autopart 
part / --fstype=ext4 --size=1024 --grow --label=root --fsoptions="defaults,usrjquota=aquota.user,grpjquota=aquota.group,jqfmt=vfsv0"
bootloader --location=mbr --append="elevator=deadline console=tty0 console=ttyS0,115200"

# Repo: CentOS url --url http://mirror.centos.org/centos/6/os/x86_64/
repo --name=updates --baseurl=http://mirror.centos.org/centos/6/updates/x86_64/
repo --name=extras  --baseurl=http://mirror.centos.org/centos/6/extras/x86_64/

%packages
@core
@ Development Tools
cloud-init
emacs-nox
mc
dstat
xorg-x11-xauth
xterm
epel-release
%end

%post --nochroot --erroronfail
set -e
install -Dp --mode=644 /cloud.cfg /mnt/sysimage/etc/cloud/cloud.cfg
quotacheck -vcguma
chroot /mnt/sysimage restorecon -Fi aquota.user aquota.group
quotaon -a
%end

%post --erroronfail
set -e
yum -y install cloud-utils-growpart
yum clean all

# hack cloud-init to execute sudo instead of runuser
sed -i 's/runuser/sudo/' /usr/lib/python2.6/site-packages/cloudinit/sources/DataSourceOpenNebula.py

# https://bugzilla.redhat.com/show_bug.cgi?id=510523
sed -i 's/rhgb//' /boot/grub/grub.conf
sed -i '/^HWADDR/d' /etc/sysconfig/network-scripts/ifcfg-eth*

# https://bugzilla.redhat.com/show_bug.cgi?id=756130
set +e
unlink /etc/udev/rules.d/70-persistent-net.rules
ln -s /dev/null /etc/udev/rules.d/70-persistent-net.rules
unlink /etc/udev/rules.d/70-persistent-cd.rules
ln -s /dev/null /etc/udev/rules.d/70-persistent-cd.rules
%end
