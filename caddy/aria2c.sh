echo "Start aria2 with standard mode"
/usr/bin/aria2c --conf-path="/root/conf/aria2.conf" -D \
--rpc-secret="$RPC_SECRET" \
&& caddy -quic --conf ${CADDY_FILE}
