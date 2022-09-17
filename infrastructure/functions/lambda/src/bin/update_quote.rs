#[macro_use]
extern crate serde;
extern crate serde_derive;
extern crate serde_json;

use std::env;
use std::process;
use lambda_http::{
  service_fn,
  IntoResponse, Request, Response,
};
use aws_sdk_dynamodb as dynamodb;
use aws_sdk_dynamodb::model::{AttributeAction, AttributeValue as AttrValue, AttributeValueUpdate};

type Error = Box<dyn std::error::Error + Send + Sync + 'static>;

#[tokio::main]
async fn main() -> Result<(), Error> {
  lambda_http::run(service_fn(func)).await?;
  Ok(())
}

#[derive(Debug, Deserialize, Default)]
struct Args {
  name: String,
  quote: String,
}

#[derive(Debug, Serialize, Default)]
struct Body {
  #[serde(default)]
  message: String
}

async fn func(event: Request) -> Result<impl IntoResponse, Error> {
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
  println!("{}", args.quote.clone());

  let attr = AttributeValueUpdate::builder()
    .action(AttributeAction::Put)
    .value(AttrValue::S(args.quote.clone()))
    .build();
  client
    .update_item()
    .table_name(table)
    .key("name", AttrValue::S(args.name.clone()))
    .attribute_updates("quote", attr)
    .send().await?;

  let body: Body = Body { message: format!("updated, {}!", args.name) };

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
