#!/bin/bash

set -e

CMD="/usr/bin/swift-proxy-server"
ARGS="/etc/swift/proxy-server.conf --verbose"

. /opt/kolla/config-swift.sh

: ${SWIFT_PROXY_BIND_IP:=$PUBLIC_IP}
: ${SWIFT_PROXY_PIPELINE_MAIN:="catch_errors gatekeeper healthcheck cache container_sync bulk ratelimit authtoken keystoneauth slo dlo proxy-server"}
: ${SWIFT_PROXY_BIND_PORT:=8080}
: ${SWIFT_USER:=swift}
: ${SWIFT_PROXY_DIR:=/etc/swift}
: ${SWIFT_PROXY_SIGNING_DIR:=/var/cache/swift}
: ${SWIFT_ADMIN_USER:=swift}
: ${SWIFT_KEYSTONE_USER:=swift}
: ${SWIFT_KEYSTONE_PASSWORD:=swift}
: ${SWIFT_PROXY_ACCOUNT_AUTOCREATE:=true}
: ${SWIFT_PROXY_OPERATOR_ROLES:=admin,user}
: ${SWIFT_PROXY_AUTH_PLUGIN:=password}
: ${SWIFT_PROXY_PROJECT_DOMAIN_ID:=default}
: ${SWIFT_PROXY_USER_DOMAIN_ID:=default}
: ${SWIFT_PROXY_PROJECT_NAME:=service}
: ${SWIFT_PROXY_USERNAME:=swift}
: ${SWIFT_PROXY_PASSWORD:=swift}
: ${SWIFT_PROXY_DELAY_AUTH_DECISION:=true}

#check_required_vars KEYSTONE_ADMIN_TOKEN NOVA_DB_PASSWORD \

export SERVICE_TOKEN="${KEYSTONE_ADMIN_TOKEN}"
export SERVICE_ENDPOINT="${KEYSTONE_AUTH_PROTOCOL}://${KEYSTONE_ADMIN_SERVICE_HOST}:${KEYSTONE_ADMIN_SERVICE_PORT}/v2.0"

crux user-create --update \
    -n "${SWIFT_KEYSTONE_USER}" \
    -p "${SWIFT_KEYSTONE_PASSWORD}" \
    -t "${ADMIN_TENANT_NAME}" \
    -r admin

crux endpoint-create --remove-all \
    -n swift -t object-store \
    -I "http://${SWIFT_API_SERVICE_HOST}:8080/v1/AUTH_%(tenant_id)s'" \
    -P "http://${PUBLIC_IP}:8080/v1/AUTH_%(tenant_id)s" \
    -A "http://${SWIFT_API_SERVICE_HOST}:8080'"

cfg=/etc/swift/proxy-server.conf

# [DEFAULT]
crudini --set $cfg DEFAULT bind_port "${SWIFT_PROXY_BIND_PORT}"
crudini --set $cfg DEFAULT user "${SWIFT_USER}"
crudini --set $cfg DEFAULT swift_dir "${SWIFT_PROXY_DIR}"
crudini --set $cfg DEFAULT bind_ip "${SWIFT_PROXY_BIND_IP}"

# [pipeline:main]
crudini --set $cfg pipeline:main pipeline "${SWIFT_PROXY_PIPELINE_MAIN}"

# [app:proxy-server]
crudini --set $cfg app:proxy-server account_autocreate "${SWIFT_PROXY_ACCOUNT_AUTOCREATE}"

# [filter:keystoneauth]
crudini --del $cfg filter:keystone
crudini --set $cfg filter:keystoneauth use egg:swift#keystoneauth
crudini --set $cfg filter:keystoneauth operator_roles "${SWIFT_PROXY_OPERATOR_ROLES}"

# [filter:container_sync]
crudini --set $cfg filter:container_sync use egg:swift#container_sync

# [filter:bulk]
crudini --set $cfg filter:bulk use egg:swift#bulk

# [filter:ratelimit]
crudini --set $cfg filter:ratelimit use egg:swift#ratelimit

# [filter:authtoken]
crudini --set $cfg filter:authtoken auth_uri \
    "http://${KEYSTONE_PUBLIC_SERVICE_HOST}:${KEYSTONE_PUBLIC_SERVICE_PORT}/"
crudini --set $cfg filter:authtoken auth_url \
    "http://${KEYSTONE_PUBLIC_SERVICE_HOST}:${KEYSTONE_ADMIN_SERVICE_PORT}/"
crudini --set $cfg filter:authtoken auth_host "${KEYSTONE_PUBLIC_SERVICE_HOST}"
crudini --set $cfg filter:authtoken auth_port "${KEYSTONE_ADMIN_SERVICE_PORT}"
crudini --set $cfg filter:authtoken admin_tenant_name "${ADMIN_TENANT_NAME}"
crudini --set $cfg filter:authtoken admin_user "${SWIFT_KEYSTONE_USER}"
crudini --set $cfg filter:authtoken admin_password "${SWIFT_KEYSTONE_PASSWORD}"
crudini --set $cfg filter:authtoken delay_auth_decision "${SWIFT_PROXY_DELAY_AUTH_DECISION}"
crudini --set $cfg filter:authtoken signing_dir "${SWIFT_PROXY_SIGNING_DIR}"

# [filter:cache]
crudini --set $cfg filter:cache memcache_servers "${PUBLIC_IP}:11211"

# Create swift user and group if they don't exist
id -u swift &>/dev/null || useradd --user-group swift

# TODO(pbourke): should these go into the Dockefile instead?
mkdir -p ${SWIFT_PROXY_SIGNING_DIR}
chown swift: ${SWIFT_PROXY_SIGNING_DIR}
chmod 0700 ${SWIFT_PROXY_SIGNING_DIR}

python /opt/kolla/build-swift-ring.py SWIFT_ACCOUNT_RING_CONF
python /opt/kolla/build-swift-ring.py SWIFT_OBJECT_RING_CONF
python /opt/kolla/build-swift-ring.py SWIFT_CONTAINER_RING_CONF

exec $CMD $ARGS
