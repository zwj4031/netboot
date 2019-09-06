#tar -zcvf samba.gz samba3
killall nmbd
killall smbd
rm -f /usr/local/etc/samba/smb.conf
cd /var/lib/tftpboot/app/tcz

tar -xvf /var/lib/tftpboot/app/tcz/samba3.gz -C /var/lib/tftpboot/app/tcz/
su tc -c 'tce-load -i /var/lib/tftpboot/app/tcz/samba3/samba3.tcz'
sudo cat << EOF > /usr/local/etc/samba/smb.conf

[global]
workgroup = WORKGROUP
netbios name = tinycong
security = user
map to guest = Bad User
#map to guest = Bad Password
usershare allow guests = yes
server min protocol = SMB2_10
client min protocol = SMB2
client max protocol = SMB3

[diyifenqu]
comment = sda1
path = /mnt/sda1
guest ok = yes
writeable = yes
directory mode = 0777
create mask = 0777
map archive = no
map hidden = no
map read only = no
map system = no
store dos attributes = yes

[tftpboot]
comment = tftpboot
path = /var/lib/tftpboot
writable = yes
public = yes
#guest ok = yes
#guest only = yes
browseable = yes
available = yes
create mask = 2777
force create mode = 0666
force directory mode = 2777
read only = No


EOF

for s in $(ls /mnt); do
mount /mnt/$s
label=$(blkid -d LABEL /dev/$s | grep 'LABEL="' | sed 's/^.*LABEL="//g' | sed 's/".*$//g') 
echo "
[($s)$label]
comment = $s
path = /mnt/$s
guest ok = yes
writeable = no
directory mode = 0777
create mask = 0777
map archive = no
map hidden = no
map read only = no
map system = no
store dos attributes = yes

[$s]
comment = $s
path = /mnt/$s
guest ok = yes
writeable = no
directory mode = 0777
create mask = 0777
map archive = no
map hidden = no
map read only = no
map system = no
store dos attributes = yes
" >>/usr/local/etc/samba/smb.conf
done

cat /usr/local/etc/samba/smb.conf

sudo mkdir -p /var/lib/samba/private
sudo /usr/local/etc/init.d/samba restart &

