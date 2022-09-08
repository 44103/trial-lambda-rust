#[macro_use]
extern crate serde;
extern crate serde_derive;
extern crate serde_json;

use std::env;
use std::process;
use lambda_http::{run, service_fn, Error, IntoResponse, Request, RequestExt, Response};
use aws_sdk_dynamodb as dynamodb;
use aws_sdk_dynamodb::model::AttributeValue;
use anyhow::{anyhow, Result};

#[derive(Debug, Serialize, Default)]
struct Body {
  #[serde(default)]
  message: String
}

/// This is the main body for the function.
/// Write your code inside it.
/// You can see more examples in Runtime's repository:
/// - https://github.com/awslabs/aws-lambda-rust-runtime/tree/main/examples
async fn function_handler(event: Request) -> Result<impl IntoResponse, Error> {
  let config = aws_config::load_from_env().await;
  let client = dynamodb::Client::new(&config);
  // Extract some useful information from the request
  let table = match env::var("TABLE") {
    Ok(val) => val,
    Err(err) => {
      println!("{err}");
      process::exit(1);
    }
  };

  let name = event.path_parameters().first("name").unwrap().to_string();
  let resp = client
    .get_item()
    .table_name(table)
    .key("name".to_string(), AttributeValue::S(name.to_string()))
    .send()
    .await?;
  let item = resp
    .item
    .ok_or_else(|| anyhow!("There is no such key: {}", name))?
    .get("quote")
    .ok_or_else(|| anyhow!("No such key in this table"))?
    .as_s()
    .unwrap()
    .to_string();
  let body: Body = Body { message: format!("{} said, {}", name, item) };

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


#[tokio::main]
async fn main() -> Result<(), Error> {
  tracing_subscriber::fmt()
    .with_max_level(tracing::Level::INFO)
    // disabling time is handy because CloudWatch will add the ingestion time.
    .without_time()
    .init();

  run(service_fn(function_handler)).await
}
