.PHONY: init plan apply destroy check create build

init:
	@docker compose run --rm terraform init

plan:
	@docker compose run --rm terraform plan

apply:
	@docker compose run --rm terraform apply -auto-approve

destroy:
	@docker compose run --rm terraform destroy

check:
	@make init
	@docker compose run --rm terraform fmt -recursive
	@docker compose run --rm terraform validate
	@make plan

create:
	@docker compose run --rm app cargo new $(FUNC) --bin
	@sudo chmod -R a+w infrastructure/functions/$(FUNC)

build:
	@docker compose run --rm app /bin/bash -c "cd $(FUNC) && rustup target add x86_64-unknown-linux-musl && cargo build --release --target x86_64-unknown-linux-musl"
