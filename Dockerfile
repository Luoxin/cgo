ARG PLATFORMS="linux/386 linux/amd64 linux/arm64 linux/arm/v5 linux/arm/v6 linux/arm/v7 linux/mips linux/mipsle linux/mips64 linux/mips64le linux/ppc64le linux/riscv64 linux/s390x windows/386 windows/amd64 darwin/amd64 darwin/arm64"
FROM --platform=$BUILDPLATFORM crazymax/goxx:latest

# osxcross
COPY --from=crazymax/osxcross /osxcross /osxcross

ENV GOXX_SKIP_APT_PORTS=1
RUN goxx-apt-get update && \
    goxx-apt-get install -y upx-ucl && \
    TARGETPLATFORM=linux/386 goxx-apt-get install -y binutils gcc g++ pkg-config &&  \
    TARGETPLATFORM=linux/amd64 goxx-apt-get install -y binutils gcc g++ pkg-config &&  \
    TARGETPLATFORM=linux/arm64 goxx-apt-get install -y binutils gcc g++ pkg-config &&  \
    TARGETPLATFORM=linux/arm/v5 goxx-apt-get install -y binutils gcc g++ pkg-config &&  \
    TARGETPLATFORM=linux/arm/v6 goxx-apt-get install -y binutils gcc g++ pkg-config &&  \
    TARGETPLATFORM=linux/arm/v7 goxx-apt-get install -y binutils gcc g++ pkg-config &&  \
    TARGETPLATFORM=linux/mips goxx-apt-get install -y binutils gcc g++ pkg-config &&  \
    TARGETPLATFORM=linux/mipsle goxx-apt-get install -y binutils gcc g++ pkg-config &&  \
    TARGETPLATFORM=linux/mips64 goxx-apt-get install -y binutils gcc g++ pkg-config &&  \
    TARGETPLATFORM=linux/mips64le goxx-apt-get install -y binutils gcc g++ pkg-config &&  \
    TARGETPLATFORM=linux/ppc64le goxx-apt-get install -y binutils gcc g++ pkg-config &&  \
    TARGETPLATFORM=linux/riscv64 goxx-apt-get install -y binutils gcc g++ pkg-config &&  \
    TARGETPLATFORM=linux/s390x goxx-apt-get install -y binutils gcc g++ pkg-config &&  \
    TARGETPLATFORM=windows/386 goxx-apt-get install -y binutils gcc g++ pkg-config &&  \
    TARGETPLATFORM=windows/amd64 goxx-apt-get install -y binutils gcc g++ pkg-config && \
    TARGETPLATFORM=darwin/arm64 goxx-apt-get install -y binutils gcc g++ pkg-config &&  \
    TARGETPLATFORM=darwin/amd64 goxx-apt-get install -y binutils gcc g++ pkg-config && \
    go env -w CGO_ENABLED=0 && \
    go env -w GO111MODULE=on && \
    go env -w GOCACHE=/tmp/gocache && \
    go env -w GOMODCACHE=/tmp/gomod && \
    go env -w GOBIN=/tmp/gobin && \
    go env -w GOPROXY=https://goproxy.cn,direct && \
    go env -w GOSUMDB=off

ENV PATH /tmp/gobin/:/usr/local/go/bin:/root/go/bin/:/usr/local/bin/:/osxcross:$PATH

WORKDIR /home/
ENTRYPOINT ["/bin/bash"]
