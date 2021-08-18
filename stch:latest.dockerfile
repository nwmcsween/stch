FROM busybox

ARG DATE="1970-01-01T00:00:00Z"
ARG REVISION="4b825dc642cb6eb9a060e54bf8d69288fbee4904"
ARG SOURCE="localhost"
ARG TITLE="stch: simple sed based templating"

LABEL org.opencontainers.image.created=${DATE}\
    org.opencontainers.image.description=${DESCRIPTION}\
    org.opencontainers.image.revision=${REVISION}\
    org.opencontainers.image.title=${TITLE}

COPY root /
ENTRYPOINT ["/bin/init"]
