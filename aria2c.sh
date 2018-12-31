conf_path=/aria2/conf
data_path=/aria2/data

userid=0 # 65534 - nobody, 0 - root
groupid=0

if [ -n "$RPC_SECRET" ]; then
    echo "rpc-secret=${RPC_SECRET}" >> $conf_path/aria2.conf
fi

if [[ -n "$PUID" && -n  "$PGID"]]; then
    userid=$PUID
    groupid=$PGID
fi

chown -R $userid:$groupid $conf_path
chown -R $userid:$groupid $data_path

caddy -quiet -conf /usr/local/caddy/Caddyfile &
su-exec $userid:$groupid aria2c --conf-path="$conf_path/aria2.conf"