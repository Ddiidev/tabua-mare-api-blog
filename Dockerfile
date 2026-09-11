FROM alpine:3.22 AS builder

ENV V_COMMIT=cf7a81ebc3cc74612b151edbfa2781e2b29b65d6 \
    VC_COMMIT=af031914695c1971c5bb309547525b4f7ddabd10 \
    VMARKDOWN_COMMIT=93fa62b02c2e7bc8e1524b7c67139f0ae462ba4f

RUN apk add --no-cache \
    build-base \
    ca-certificates \
    gc-dev \
    git \
    openssl-dev \
    pax-utils \
    pkgconf

RUN git init /opt/v \
    && git -C /opt/v remote add origin https://github.com/vlang/v.git \
    && git -C /opt/v fetch --depth=1 origin "${V_COMMIT}" \
    && git -C /opt/v checkout --detach FETCH_HEAD \
    && git init /opt/v/vc \
    && git -C /opt/v/vc remote add origin https://github.com/vlang/vc.git \
    && git -C /opt/v/vc fetch --depth=1 origin "${VC_COMMIT}" \
    && git -C /opt/v/vc checkout --detach FETCH_HEAD \
    && make -C /opt/v fresh_tcc \
    && make -C /opt/v local=1 \
    && test "$(git -C /opt/v rev-parse HEAD)" = "${V_COMMIT}" \
    && test "$(git -C /opt/v/vc rev-parse HEAD)" = "${VC_COMMIT}" \
    && /opt/v/v version | grep -F 'V 0.5.2'

RUN mkdir -p /root/.vmodules/guweigang \
    && git init /root/.vmodules/guweigang/vmarkdown \
    && git -C /root/.vmodules/guweigang/vmarkdown remote add origin https://github.com/guweigang/vmarkdown.git \
    && git -C /root/.vmodules/guweigang/vmarkdown fetch --depth=1 origin "${VMARKDOWN_COMMIT}" \
    && git -C /root/.vmodules/guweigang/vmarkdown checkout --detach FETCH_HEAD \
    && test "$(git -C /root/.vmodules/guweigang/vmarkdown rev-parse HEAD)" = "${VMARKDOWN_COMMIT}"

WORKDIR /src
COPY . .

RUN /opt/v/v \
    -cc gcc \
    -ldflags "-Wl,--gc-sections -ffunction-sections -fdata-sections" \
    -gc boehm_incr_opt \
    -d use_openssl \
    -d new_veb \
    -prod \
    . \
    -o TabuaMareBlog \
    && scanelf --needed --nobanner TabuaMareBlog \
    && ldd TabuaMareBlog | tee /tmp/ldd.txt \
    && ! grep -Fq 'not found' /tmp/ldd.txt

FROM alpine:3.22 AS runtime

LABEL org.opencontainers.image.source="https://github.com/Ddiidev/tabua-mare-api-blog"

RUN apk add --no-cache \
    ca-certificates \
    curl \
    gc \
    libcrypto3 \
    libgcc \
    libssl3 \
    tini \
    tzdata \
    && addgroup -S -g 10001 app \
    && adduser -S -D -H -u 10001 -G app app

WORKDIR /app

COPY --from=builder /src/TabuaMareBlog /app/TabuaMareBlog
COPY --from=builder /src/assets /app/assets
COPY --from=builder /src/posts /app/posts
COPY --from=builder /src/db.json /app/db.json

RUN chmod 0755 /app/TabuaMareBlog \
    && chmod -R a=rX /app/assets /app/posts /app/db.json

ENV BLOG_BASE_PATH=/blog \
    PORT=8080 \
    TZ=America/Sao_Paulo

EXPOSE 8080
USER app

HEALTHCHECK --interval=10s --timeout=3s --start-period=15s --retries=3 \
    CMD curl -fsS -o /dev/null http://127.0.0.1:${PORT}/health || exit 1

ENTRYPOINT ["/sbin/tini", "--", "/app/TabuaMareBlog"]
