#!/bin/bash

if [[ -f /opt/kolla/swift/swift.conf ]]; then
    cp /opt/kolla/swift/swift.conf /etc/swift/
    chown root:swift /opt/kolla/swift/swift.conf
    chmod 0644 /opt/kolla/swift/swift.conf
fi

if [[ -f /opt/kolla/swift/object-expirer.conf ]]; then
    cp /opt/kolla/swift/object-expirer.conf /etc/swift/
    chown root:swift /opt/kolla/swift/object-expirer.conf
    chmod 0644 /opt/kolla/swift/object-expirer.conf
fi
