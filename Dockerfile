# syntax=docker/dockerfile:1
# SPDX-License-Identifier: Apache-2.0

FROM alpine/git:2.52.0@sha256:e6c6c4fd5fdb742d681fcdc6018cad699ca0a75909f7fe788e626b542a9c0438
LABEL maintainer="honeok <i@honeok.com>"
RUN set -ex \
    && apk add --no-cache --update bash
COPY --chmod=755 *.sh /
ENTRYPOINT ["/entrypoint.sh"]
