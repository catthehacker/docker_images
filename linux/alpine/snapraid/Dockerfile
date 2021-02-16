FROM alpine:3.13 AS build
RUN apk add --update --no-cache build-base git make autoconf automake
RUN git clone https://github.com/amadvance/snapraid \
    && cd snapraid \
    && git reset 922719c1d734f27c82bf99112f8cbf97157db628 --hard \
    && ./autogen.sh \
    && ./configure LDFLAGS=-static CFLAGS=-Bstatic --prefix="$(pwd)"/build \
    && make && make install

FROM scratch
COPY --from=build /snapraid/build/bin/snapraid /snapraid
ENTRYPOINT ["/snapraid"]
