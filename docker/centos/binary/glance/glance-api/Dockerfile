FROM %%KOLLA_NAMESPACE%%/%%KOLLA_PREFIX%%glance-base:%%KOLLA_TAG%%
MAINTAINER Kolla Project (https://launchpad.net/kolla)

ADD ./start.sh /start.sh
ADD ./check.sh /check.sh

CMD ["/start.sh"]
