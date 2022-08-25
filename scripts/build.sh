#!/bin/bash

cd infrastructure/functions/lambda
rustup target add x86_64-unknown-linux-musl
for func in $(basename src/bin/*.rs .rs); do
  cargo build --release --target x86_64-unknown-linux-musl --bin $func
  mkdir -p ./dist/$func/bin
  cp ./target/x86_64-unknown-linux-musl/release/$func ./dist/$func/bin/bootstrap
done
