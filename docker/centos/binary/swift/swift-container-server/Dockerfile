FROM %%KOLLA_NAMESPACE%%/%%KOLLA_PREFIX%%swift-object-base:%%KOLLA_TAG%%
MAINTAINER Kolla Project (https://launchpad.net/kolla)

RUN yum -y install \
        openstack-swift-container.noarch \
    && yum clean all

COPY start.sh /
CMD ["/start.sh"]
