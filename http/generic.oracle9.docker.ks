text
reboot --eject
lang en_US.UTF-8
keyboard us
timezone US/Pacific
rootpw --plaintext locked

zerombr
clearpart --all --initlabel
part /boot --fstype="xfs" --size=1024 --label=boot
part pv.01 --fstype="lvmpv" --grow
volgroup oracle --pesize=4096 pv.01
logvol swap --fstype="swap" --size=2048 --name=swap --vgname=oracle
logvol / --fstype="xfs" --percent=100 --label="root" --name=root --vgname=oracle

firewall --enabled --service=ssh
authconfig --enableshadow --passalgo=sha512
network --device eth0 --bootproto dhcp --noipv6 --hostname=oracle9.localdomain
bootloader --timeout=1 --append="net.ifnames=0 biosdevname=0 no_timer_check vga=792 nomodeset text"

url --url=https://yum.oracle.com/repo/OracleLinux/OL9/baseos/latest/x86_64/
repo --name=appstream --baseurl=https://yum.oracle.com/repo/OracleLinux/OL9/appstream/x86_64/

%packages
@core
sudo
-fprintd-pam
-intltool
-iwl*-firmware
-microcode_ctl
%end

%post

sed -i -e "s/.*PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config
sed -i -e "s/.*PasswordAuthentication.*/PasswordAuthentication yes/g" /etc/ssh/sshd_config

cat <<-EOF > /etc/udev/rules.d/60-scheduler.rules
# Set the default scheduler for various device types and avoid the buggy bfq scheduler.
ACTION=="add|change", KERNEL=="sd[a-z]|sg[a-z]|vd[a-z]|hd[a-z]|xvd[a-z]|dm-*|mmcblk[0-9]*|nvme[0-9]*", ATTR{queue/scheduler}="mq-deadline"
EOF

%end