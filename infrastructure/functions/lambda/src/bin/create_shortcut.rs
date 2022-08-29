#[macro_use]
extern crate serde;
extern crate serde_derive;
extern crate serde_json;

use std::env;
use std::process;
use lambda_http::{
  handler,
  lambda_runtime::{self, Context},
  IntoResponse, Request, Response,
};
use aws_sdk_dynamodb as dynamodb;
use aws_sdk_dynamodb::model::AttributeValue;

type Error = Box<dyn std::error::Error + Send + Sync + 'static>;

#[tokio::main]
async fn main() -> Result<(), Error> {
  lambda_runtime::run(handler(func)).await?;
  Ok(())
}

#[derive(Debug, Deserialize, Default)]
struct Args {
  #[serde(default)]
  name: String,
  #[serde(default)]
  keys: Vec<String>,
  #[serde(default)]
  desc: String
}

#[derive(Debug, Serialize, Default)]
struct Body {
  #[serde(default)]
  message: String
}

async fn func(event: Request, _: Context) -> Result<impl IntoResponse, Error> {
  let args: Args = serde_json::from_slice(event.body().as_ref()).unwrap();

  let config = aws_config::load_from_env().await;
  let client = dynamodb::Client::new(&config);

  let table = match env::var("TABLE") {
    Ok(val) => val,
    Err(err) => {
      println!("{err}");
      process::exit(1);
    }
  };
  client
    .put_item()
    .table_name(table)
    .item("name", AttributeValue::S(args.name.clone()))
    .item("keys", AttributeValue::Ss(args.keys))
    .item("desc", AttributeValue::S(args.desc))
    .send().await?;

  let body: Body = Body { message: format!("registerd {}", args.name.clone()) };

  Ok(Response::builder()
    .status(200)
    .header("Content-Type", "application/json")
    .header("Access-Control-Allow-Methods", "OPTIONS,POST,GET")
    .header("Access-Control-Allow-Credential", "true")
    .header("Access-Control-Allow-Origin", "*")
    .body(serde_json::to_string(&body).unwrap())
    .expect("failed to render response")
  )
}
