FROM starkandwayne/redis:latest

COPY scripts /scripts
RUN chmod +x /scripts/*.sh

ADD scripts/sanity-test.sh /usr/bin/sanity-test
RUN chmod +x /scripts/*.sh /usr/bin/sanity-test
ENV PATH="${PATH}:/usr/bin"

ENTRYPOINT ["/scripts/entry.sh", "start", "starkandwayne/redis"]
