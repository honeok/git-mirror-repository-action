# syntax=docker/dockerfile:1
# SPDX-License-Identifier: Apache-2.0

FROM alpine/git:2.52.0@sha256:d46d88ab234733c6b6a9771acd6d1384172fd0e2224e0232bdae32ec671aa099
LABEL maintainer="honeok <i@honeok.com>"
RUN set -ex \
    && apk add --no-cache --update bash
COPY --chmod=755 *.sh /
ENTRYPOINT ["/entrypoint.sh"]
