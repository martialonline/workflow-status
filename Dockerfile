FROM alpine:3.12

LABEL maintainer="David Boenig <dave@martial.sh>"
LABEL repository="https://github.com/martialonline/workflow-status"

RUN apk add --no-cache curl jq

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]