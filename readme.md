# Rust Hello World Test

## Lambda新規作成
```sh
docker compose run --rm app cargo new <Lambda関数名> --bin
sudo chmod -R a+w functions/<Lambda関数名>
```
or
```sh
make create FUNC=<Lambda関数名>
```

## コンパイル確認
```sh
docker compose run --rm app /bin/bash -c "cd <Lambda関数名> && cargo check"
```

## ビルド
```sh
docker compose run --rm app /bin/bash -c "cd <Lambda関数名> && rustup target add x86_64-unknown-linux-musl && cargo build --release --target x86_64-unknown-linux-musl"
```
or
```sh
make build FUNC=<Lambda関数名>
```
