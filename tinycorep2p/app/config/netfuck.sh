#tar -zcvf samba.gz samba3


#wget -c https://gitee.com/zwj4031/netboot/raw/master/tinycorep2p/app/config/netfuck.sh -O /netfuck.sh
#wget -c http://raw.githubusercontent.com/zwj4031/netboot/master/tinycorep2p/app/config/netfuck.sh -O /netfuck.sh
export cloudurl=http://raw.githubusercontent.com/zwj4031/netboot/master/tinycorep2p
#export cloudurl=https://gitee.com/zwj4031/netboot/raw/master/tinycorep2p




rm -f /etc/profile.d/getsh.sh
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




wget -c $cloudurl/app/tcz/app.lst -O /var/lib/tftpboot/app/tcz/app.lst

for tczs in $(cat /var/lib/tftpboot/app/tcz/app.lst); do

wget -c  $cloudurl/app/tcz/$tczs -O /var/lib/tftpboot/app/tcz/$tczs
done



su tc -c 'tce-load -i /var/lib/tftpboot/app/tcz/xbase.tcz'

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
#开始执行任务

cd /var/lib/tftpboot/app/tcz
sh /samba3.sh

sudo /var/lib/tftpboot/app/tcz/verysync -home data -gui-address :8886 &

echo verysync P2P is running $p2pmode mode on port:8886 ...... >>/var/lib/tftpboot/index.html
echo verysync P2P is running $p2pmode mode on port:8886 ...... >>/var/lib/tftpboot/notice.txt

