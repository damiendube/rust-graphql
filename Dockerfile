FROM scratch

ADD target/x86_64-unknown-linux-musl/release/rust-graphql /

EXPOSE 8080

ENTRYPOINT ["/rust-graphql"]