#!/bin/bash

docker/centos/binary/swift/swift-base/build --release && \
docker/centos/binary/swift/swift-data/build --release && \
docker/centos/binary/swift/swift-object-base/build --release && \
docker/centos/binary/swift/swift-object-server/build --release && \
docker/centos/binary/swift/swift-object-auditor/build --release && \
docker/centos/binary/swift/swift-object-expirer/build --release && \
docker/centos/binary/swift/swift-object-replicator/build --release && \
docker/centos/binary/swift/swift-object-updater/build --release && \
docker/centos/binary/swift/swift-account-server/build --release && \
docker/centos/binary/swift/swift-proxy-server/build --release && \
docker/centos/binary/memcached/build --release && \
docker/centos/binary/swift/swift-container-server/build --release
