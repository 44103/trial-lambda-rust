.PHONY: init plan apply destroy check create build

init:
	@docker compose run --rm tf-exec init

plan:
	@docker compose run --rm tf-exec plan

apply:
	@docker compose run --rm tf-exec apply -auto-approve

destroy:
	@docker compose run --rm tf-exec destroy -auto-approve

check:
	@docker compose run --rm tf-check fmt -recursive
	@make init
	@docker compose run --rm tf-check validate
	@make plan

console:
	@docker compose run --rm tf-cli

create:
	@docker compose run --rm app cargo new lambda --bin
	@sudo chmod -R a+w infrastructure/functions/lambda

build:
	@docker compose run --rm app ./scripts/build.sh
