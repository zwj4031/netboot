#tar -zcvf samba.gz samba3

set -- $(cat /proc/cmdline)
for x in "$@"; do
case "$x" in
http=*)
export http="${x#http=}"
;;

p2p=*)
export p2p="${x#p2p=}"
;;
esac
done
killall verysync


mkdir /var/lib/tftpboot
mkdir /var/lib/tftpboot/app
mkdir /var/lib/tftpboot/app/tcz




wget -c http://$http/app/tcz/app.lst -O /var/lib/tftpboot/app/tcz/app.lst

for tczs in $(cat /var/lib/tftpboot/app/tcz/app.lst); do

wget -c http://$http/app/tcz/$tczs -O /var/lib/tftpboot/app/tcz/$tczs
done


tar -xvf /var/lib/tftpboot/app/tcz/samba3.gz -C /var/lib/tftpboot/app/tcz/
su tc -c 'tce-load -i /var/lib/tftpboot/app/tcz/samba3/samba3.tcz'
su tc -c 'tce-load -i /var/lib/tftpboot/app/tcz/xbase.tcz'


echo verysync P2P is running $p2pmode mode on port:8886 ...... >>/var/lib/tftpboot/index.html
echo verysync P2P is running $p2pmode mode on port:8886 ...... >>/var/lib/tftpboot/notice.txt
clear
echo found verysync! ............

mountntfsrw(){
for i in $(ls /mnt); do
umount /mnt/$i
ntfs-3g /dev/$i /mnt/$i
done
}

if [ $p2p = "client" ]
then
mountntfsrw
export p2pmode="client"
else
export p2pmode="server"
fi

sleep 3
cd /var/lib/tftpboot/app/tcz
sudo /var/lib/tftpboot/app/tcz/verysync -home data -gui-address :8886 &


