echo $(date) "Sending save-all to server"

{
echo "/save-off"
sleep 2
echo "/save-all flush"
sleep 10
} | ncat localhost 7777

echo $(date) "Syncing world to backup"

rsync --rsh "ssh -i $RSYNCKEY" -av --inplace --delete /minecraft/host/mcdata/world $RSYNCDEST:$SERVERNAME
restic backup /minecraft/host/mcdata/world
sleep 10
{
echo "/save-on"
sleep 1
} | ncat localhost 7777

echo $(date) "sync done"
