#!/bin/sh

conf_path=/aria2/conf
conf_copy_path=/aria2/conf-copy
data_path=/aria2/data
ariang_js_path=/usr/local/www/ariang/js/aria-ng*.js

# If config does not exist - use default
if [ ! -f $conf_path/aria2.conf ]; then
    cp $conf_copy_path/aria2.conf $conf_path/aria2.conf
fi

if [ -n "$RPC_SECRET" ]; then
    sed -i '/^rpc-secret=/d' $conf_path/aria2.conf
    printf 'rpc-secret=%s\n' "${RPC_SECRET}" >>$conf_path/aria2.conf

    if [ -n "$EMBED_RPC_SECRET" ]; then
        echo "Embedding RPC secret into ariang Web UI"
        RPC_SECRET_BASE64=$(echo -n "${RPC_SECRET}" | base64 -w 0)
        sed -i 's,secret:"[^"]*",secret:"'"${RPC_SECRET_BASE64}"'",g' $ariang_js_path
    fi
fi

if [ -n "$BASIC_AUTH_USERNAME" ] && [ -n "$BASIC_AUTH_PASSWORD" ]; then
    echo "Enabling caddy basic auth"
    echo "
        basicauth / {
            $BASIC_AUTH_USERNAME $(caddy hash-password -plaintext "${BASIC_AUTH_PASSWORD}")
        }
    " >>/usr/local/caddy/Caddyfile
fi

touch $conf_path/aria2.session

userid="$(id -u)" # 65534 - nobody, 0 - root
groupid="$(id -g)"

if [[ -n "$PUID" && -n "$PGID" ]]; then
    echo "Running as user $PUID:$PGID"
    userid=$PUID
    groupid=$PGID
fi

chown -R "$userid":"$groupid" $conf_path
chown -R "$userid":"$groupid" $data_path

caddy start -config /usr/local/caddy/Caddyfile -adapter=caddyfile
su-exec "$userid":"$groupid" aria2c "$@"
