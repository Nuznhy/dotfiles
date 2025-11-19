for i in `seq 1 254`; do
ping -c 1 -q 192.168.1.$i &
done
