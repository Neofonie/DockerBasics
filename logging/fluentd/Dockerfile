FROM fluent/fluentd

RUN apk update && apk add --no-cache curl jq && \
    apk add --no-cache --virtual .build-deps build-base ruby-dev \
# https://github.com/fluent/fluentd/issues/1866
    && gem uninstall oj && gem install oj -v 2.18.3 \
    && fluent-gem install fluent-plugin-elasticsearch -v 2.6.1 \
    && fluent-gem install fluent-plugin-record-reformer -v 0.9.1 \
    && fluent-gem install fluent-plugin-concat \
    && fluent-gem install fluent-plugin-monolog \
    && fluent-gem install fluent-plugin-multi-format-parser \
    && apk del .build-deps \
    && rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /usr/lib/ruby/gems/*/cache/*.gem

#RUN apk update && \
#    apk add --no-cache --virtual .build-deps build-base ruby-dev \
#    && fluent-gem install fluent-plugin-elasticsearch \
#    && fluent-gem install fluent-plugin-record-reformer \
#    && apk del .build-deps \
#    && rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /usr/lib/ruby/gems/*/cache/*.gem

ADD entrypoint.sh /bin/

ADD etc/fluentd.conf /fluentd/etc/fluentd.conf

VOLUME ["/fluentd/log"]
