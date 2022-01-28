FROM docker.io/multiarch/crossbuild:latest@sha256:8dbaa86462270db93ae1b1b319bdd88d89272faf3a68632daf4fa36b414a326e

# install cosign
COPY --from=ghcr.io/sigstore/cosign/cosign:6575648f069f8f7aa7f72ec2b0e38b77914f2883@sha256:1361aa271fd2c945dddef0e6bdef907aff745c88f9fab0ed27ec46c96b70102f /ko-app/cosign /usr/local/bin/cosign

# install syft
COPY --from=docker.io/anchore/syft:v0.36.0@sha256:305e1777f6e105bfd4cc9a06faceefabb0a5c6c59d854013b4068c7ee7b310ba /syft /usr/local/bin/syft

# install upx
COPY --from=docker.io/hairyhenderson/upx:3.94@sha256:e653c4c34539b6de164461b3e29ac4b821dcf708e9f4b831bfa8f5824623c5ef /usr/bin/upx /usr/local/bin/upx

# install go
COPY --from=docker.io/golang:1.17.6@sha256:ec67c62f48ddfbca1ccaef18f9b3addccd707e1885fa28702a3954340786fcf6 /usr/local/go /usr/local/go
ENV PATH /usr/local/go/bin:$PATH

# install goreleaser
COPY --from=docker.io/goreleaser/goreleaser:1.4.1@sha256:b216450b9a207975b45ec572ab7c3eb6c56ee4ca44f8672bdb9a76b7da61c316 /usr/local/bin/goreleaser /usr/local/bin/goreleaser

RUN go env -w CGO_ENABLED=1 && \
    go env -w GO111MODULE=on && \
    go env -w GOCACHE=/tmp/gocache && \
    go env -w GOMODCACHE=/tmo/gomod

WORKDIR /home/
ENTRYPOINT ["/bin/bash"]
