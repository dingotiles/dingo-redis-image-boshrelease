FROM starkandwayne/redis:latest

COPY scripts /scripts
RUN chmod +x /scripts/*.sh

ENTRYPOINT ["/scripts/entry.sh", "start", "starkandwayne/redis"]
