# Rust Hello World Test

## Lambda新規作成
1. 初期化
   ```sh
   make create
   ```
1. 新規関数作成
   `infrastructure/functions/lambda/src/bin/`に新規作成するLambda関数名でRustファイルを作成
1. `infrastructure/service/main.tf`に以下のような内容を記述
   ```hcl
   module "lambda" {
      commons = local.commons
      source  = "../modules/lambda"
      name    = "<Lambda関数名>"
   }
   ```
1. ビルド
   ```sh
   make build FUNC=<Lambda関数名>
   ```

## 動作確認
API Gateway (REST) の場合
```sh
curl -X POST -H "Content-Type: application/json" -d '{"name": "circleci"}' 'https://<URI>/prod/greet'
```

API Gateway v2 (HTTP) の場合
```sh
curl -X POST -H "Content-Type: application/json" -d '{"name": "circleci"}' 'https://<URI>/greet'
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
