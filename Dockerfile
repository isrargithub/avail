FROM rust:1 AS builder
LABEL maintainer "Pierre Krieger <pierre.krieger1708@gmail.com>"

COPY . /build
WORKDIR /build

RUN apt-get update && apt-get install -y musl-tools
# TODO: don't use nightly once possible
RUN rustup default nightly
RUN rustup target add x86_64-unknown-linux-musl
RUN cargo build --target x86_64-unknown-linux-musl --bin full-node --release --verbose --all-features


FROM alpine:latest
LABEL maintainer "Pierre Krieger <pierre.krieger1708@gmail.com>"
COPY --from=builder /build/target/x86_64-unknown-linux-musl/release/full-node /usr/local/bin

EXPOSE 30333
CMD ["/usr/local/bin/full-node"]
