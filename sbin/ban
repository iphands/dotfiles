#!/bin/bash
set -e

if [ "$1" != "FULL" ]
then
  opt="300 minutes ago"
else
  opt="7 days ago"
fi

LIST_FILE="/root/ban/.ip.list.txt"
BANLOG_FILE="/root/ban/.ban.log"
LIST_FILE_RAW="${LIST_FILE}.raw"
LIST_FILE_TMP="${LIST_FILE}.bak"

OLD_COUNT="`fgrep from $LIST_FILE_RAW 2>/dev/null | wc -l 2>/dev/null`"

echo "Finding bad actors"
time journalctl -u sshd --since="${opt}" | fgrep 'Failed password' | fgrep ' from ' | egrep -o 'from [0-9\.]*' >> $LIST_FILE_RAW
cat $LIST_FILE_RAW | sort -u | cut -f2 -d' ' > $LIST_FILE

echo "Bouncing firewall"
# systemctl restart firewall
firewall-cmd --reload

MY_IP=`cat /root/ban/myip.txt`
echo "Adding bad actors"
for IP in `cat $LIST_FILE`
do
  if [[ "$MY_IP" != "$IP" ]]; then
    echo "  adding $IP"
    # iptables -w 60 -A IN_public_deny -s $IP -j REJECT
    firewall-cmd --add-rich-rule="rule family='ipv4' source address='$IP' reject"
  fi
done

echo "Old count:"
echo $OLD_COUNT

echo "New count:"
wc -l $LIST_FILE | awk '{print $1}'
echo "`wc -l $LIST_FILE | awk '{print $1}'` `date`" >> $BANLOG_FILE

cp $LIST_FILE_RAW $LIST_FILE_TMP
sort -u $LIST_FILE_TMP | fgrep -v 'from from' > $LIST_FILE_RAW
rm $LIST_FILE_TMP
