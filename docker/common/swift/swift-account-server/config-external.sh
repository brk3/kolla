#!/bin/bash

if [[ -f /opt/kolla/swift/swift.conf ]]; then
    cp /opt/kolla/swift/swift.conf /etc/swift/
    chown root:swift /opt/kolla/swift/swift.conf
    chmod 0644 /opt/kolla/swift/swift.conf
fi

if [[ -f /opt/kolla/swift/account-server.conf ]]; then
    cp /opt/kolla/swift/account-server.conf /etc/swift/
    chown root:swift /opt/kolla/swift/account-server.conf
    chmod 0644 /opt/kolla/swift/account-server.conf
fi
