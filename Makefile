.PHONY: install

install:
	yarn install

config/config.conf:
	npx merminator -f docs/ava.mermaid
