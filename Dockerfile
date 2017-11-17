FROM pytorch/pytorch
ENV RUST_VER=1.20.0
RUN curl -sO https://static.rust-lang.org/dist/rust-${RUST_VER}-x86_64-unknown-linux-gnu.tar.gz && \
    tar -xzf rust-${RUST_VER}-x86_64-unknown-linux-gnu.tar.gz && \
    ./rust-${RUST_VER}-x86_64-unknown-linux-gnu/install.sh --without=rust-docs && \
    curl -sO https://static.rust-lang.org/dist/rust-std-${RUST_VER}-x86_64-unknown-linux-musl.tar.gz && \
    tar -xzf rust-std-${RUST_VER}-x86_64-unknown-linux-musl.tar.gz && \
    ./rust-std-${RUST_VER}-x86_64-unknown-linux-musl/install.sh --without=rust-docs
ENV BINDGEN_VERSION 0.25.1
RUN cargo install bindgen --vers ${BINDGEN_VERSION}
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get  -y install libclang1

COPY generate_bindings .
COPY Cargo.toml .
ENV PATH /root/.cargo/bin/:$PATH
WORKDIR /workspace
RUN chmod -R a+w /workspace
CMD bash generate_bindings && cargo build --release --verbose 
