#[macro_use]
extern crate serde;
extern crate serde_derive;
extern crate serde_json;

use lambda_http::{
  handler,
  lambda_runtime::{self, Context},
  IntoResponse, Request, Response,
};

type Error = Box<dyn std::error::Error + Send + Sync + 'static>;

#[tokio::main]
async fn main() -> Result<(), Error> {
  lambda_runtime::run(handler(func)).await?;
  Ok(())
}

#[derive(Debug, Deserialize, Default)]
struct Args {
  #[serde(default)]
  name: String
}

#[derive(Debug, Serialize, Default)]
struct Body {
  #[serde(default)]
  message: String
}

async fn func(event: Request, _: Context) -> Result<impl IntoResponse, Error> {
  let args: Args = serde_json::from_slice(event.body().as_ref()).unwrap();
  let body: Body = Body { message: format!("Hello {}", args.name) };
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
