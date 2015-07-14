FROM %%KOLLA_NAMESPACE%%/%%KOLLA_PREFIX%%base:%%KOLLA_TAG%%
MAINTAINER Kolla Project (https://launchpad.net/kolla)

VOLUME [ "/srv/node/sdb1" ]
VOLUME [ "/srv/node/sdb2" ]
VOLUME [ "/srv/node/sdb3" ]

# Command needed to start the data container.
# Note: data containers do not need to be persistent.
CMD ["/bin/bash"]
