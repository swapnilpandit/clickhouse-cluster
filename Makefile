.PHONY: config
config:
	@for i in 01 02 03; do \
		rm -rf clickhouse$$i ; \
		mkdir -p clickhouse$$i ; \
		REPLICA=$$i SHARD=$$i envsubst < config.yaml > clickhouse$$i/config.yaml ; \
		cp users.yaml clickhouse$$i/users.yaml ; \
	done
	@echo "config generated"
