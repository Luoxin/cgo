ARG PLATFORMS="linux/386 linux/amd64 linux/arm64 linux/arm/v5 linux/arm/v6 linux/arm/v7 linux/mips linux/mipsle linux/mips64 linux/mips64le linux/ppc64le linux/riscv64 linux/s390x windows/386 windows/amd64 darwin/amd64 darwin/arm64"
FROM --platform=$BUILDPLATFORM crazymax/goxx:latest

# install cosign
COPY --from=ghcr.io/sigstore/cosign/cosign:6575648f069f8f7aa7f72ec2b0e38b77914f2883@sha256:1361aa271fd2c945dddef0e6bdef907aff745c88f9fab0ed27ec46c96b70102f /ko-app/cosign /usr/local/bin/cosign

# install syft
COPY --from=docker.io/anchore/syft:v0.36.0@sha256:305e1777f6e105bfd4cc9a06faceefabb0a5c6c59d854013b4068c7ee7b310ba /syft /usr/local/bin/syft

# install upx
COPY --from=docker.io/hairyhenderson/upx:3.94@sha256:e653c4c34539b6de164461b3e29ac4b821dcf708e9f4b831bfa8f5824623c5ef /usr/bin/upx /usr/local/bin/upx

# install goreleaser
COPY --from=docker.io/goreleaser/goreleaser:v1.12.2@sha256:144aa3cac0fed4d8998798a0ece33785e50493e58a7393c3d9f5b95397faf174 /usr/bin/goreleaser /usr/local/bin/goreleaser

# osxcross
COPY --from=crazymax/osxcross /osxcross /osxcross

RUN goxx-apt-get update && \
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

WORKDIR /home/embla/
ENTRYPOINT ["/bin/bash"]
