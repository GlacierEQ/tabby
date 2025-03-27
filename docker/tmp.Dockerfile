FROM rust:1.70-slim-bullseye as builder

WORKDIR /app
RUN apt-get update && apt-get install -y \
    cmake \
    build-essential \
    git \
    pkg-config \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Cache dependencies
COPY Cargo.toml Cargo.lock ./
COPY crates ./crates
RUN mkdir src && \
    echo "fn main() {}" > src/main.rs && \
    cargo build --release && \
    rm -rf src

# Build application
COPY . .
RUN cargo build --release

FROM debian:bullseye-slim as runtime

WORKDIR /app
RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    libssl1.1 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/target/release/tabby .
COPY --from=builder /app/config ./config

ENV RUST_LOG=info
EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s CMD curl -f http://localhost:8080/health || exit 1
