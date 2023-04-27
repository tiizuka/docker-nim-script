FROM alpine AS builder

RUN apk add -U --no-cache \
            gcc \
            musl-dev \
            file \
            upx \
    && wget https://nim-lang.org/download/nim-1.6.12.tar.xz \
    && tar xfJ nim-1.6.12.tar.xz \
    && cd nim-1.6.12 \
    && LDFLAGS=-static sh build.sh \
    && cd bin \
                 && file nim && ls -l nim && sha256sum nim \
    && strip nim && file nim && ls -l nim && sha256sum nim \
    && upx nim   && file nim && ls -l nim && sha256sum nim \
    && ./nim -v


FROM scratch

COPY --from=builder /nim-1.6.12/bin/nim        /
COPY --from=builder /nim-1.6.12/lib            /lib
COPY --from=builder /nim-1.6.12/config/nim.cfg /

ENTRYPOINT ["/nim"]
