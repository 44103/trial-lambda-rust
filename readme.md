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

## 参考
- [[Rust] 文字列リテラル: エスケープあるいは raw string](https://qiita.com/osanshouo/items/59790f5fcd515a0ae559)
- [Makefile で第2引数を使う方法](https://qiita.com/algas/items/499d0d69d51a1cc7639f)
- [RustとLambdaでなんか作る 中編](https://qiita.com/ikegam1/items/0537ba51ac4ddbe02a8e#%E3%81%84%E3%81%98%E3%82%8B)
- [RustでAWS Lambda関数を作る(WSL2編)](https://zenn.dev/upopon/articles/622701b5a6c9ba)
- [RustとAWS Lambda・Amazon API GatewayでサーバレスWeb APIを作る方法](https://zenn.dev/uedayou/articles/22252000441999)
- [terraformのnull_resourceが便利だよ！という話](https://qiita.com/eigo_s/items/0dd6ffc84e1732eff703)
- [docker-compose + makeで作る最強のTerraformローカル実行環境](https://qiita.com/Tocyuki/items/0cb655e6357d9bf0c40f)
- [docker-composeでTerraformのAWS構築環境を作成する 【AWS CLI 2対応】](https://zenn.dev/foolishell/articles/69a9200596560e)
- [Rust で AWS Lambda を利用する手順まとめ](https://komorinfo.com/blog/rust-aws-lambda/)
- [今さらRustランタイムを使用してAWS Lambdaで関数を作成してみたのだが...](https://qiita.com/mwataame/items/5247a1deb98e68561413)
- [Lambda+Rustのデプロイメントをコンテナイメージと.zipファイルアーカイブの両方で試す](https://qiita.com/c3drive/items/67b95f36a27743c72962)
- [RustアプリのコンテナイメージをLambdaで動かしてみた #reinvent](https://dev.classmethod.jp/articles/rust-app-container-on-lambda-function/)
- [AWS Lambda and Rust: Building AWS Lambda functions with Terraform pt. 1](https://medium.com/@jakub.jantosik/aws-lambda-and-rust-building-aws-lambda-functions-with-terraform-pt-1-a09e5c0a0cb9)
