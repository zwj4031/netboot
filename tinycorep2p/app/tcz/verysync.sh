#tar -zcvf samba.gz samba3
killall verysync

set -- $(cat /proc/cmdline)
for x in "$@"; do 
case "$x" in
p2p=*)
export p2p="${x#p2p=}"
;;

esac
done


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

echo verysync P2P is running $p2pmode mode on port:8886 ...... >>/var/lib/tftpboot/index.html
echo verysync P2P is running $p2pmode mode on port:8886 ...... >>/var/lib/tftpboot/notice.txt
clear
echo found verysync! ............
sleep 3
cd /var/lib/tftpboot/app/tcz
sudo /var/lib/tftpboot/app/tcz/verysync -home data -gui-address :8886 &


