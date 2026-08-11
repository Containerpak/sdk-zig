FROM ubuntu:26.04 AS fetch

ARG ZIG_VERSION=0.16.0
ARG ZIG_SHA256=70e49664a74374b48b51e6f3fdfbf437f6395d42509050588bd49abe52ba3d00

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates curl xz-utils && \
    curl -fsSLo /tmp/zig.tar.xz "https://ziglang.org/download/${ZIG_VERSION}/zig-x86_64-linux-${ZIG_VERSION}.tar.xz" && \
    echo "${ZIG_SHA256}  /tmp/zig.tar.xz" | sha256sum -c - && \
    mkdir -p /opt/zig && \
    tar -C /opt/zig --strip-components=1 -xf /tmp/zig.tar.xz

FROM ghcr.io/containerpak/base-sdk:main

COPY --from=fetch /opt/zig /opt/zig

RUN ln -s /opt/zig/zig /usr/local/bin/zig

ENV PATH=/usr/local/bin:${PATH}
