CONFIG_PATH=${HOME}/.rito/

.PHONY: build
build: # Build the project
	@go build -o bin/ ./...

.PHONY: docker/build
docker/build: # Build the server into a docker image
	@docker build -t briancain/rito:0.0.1 . 

.PHONY: proto
proto: # Generates the protobufs
	@protoc api/v1/*.proto \
		--go_out=. \
		--go-grpc_out=. \
		--go_opt=paths=source_relative \
		--go-grpc_opt=paths=source_relative \
		--proto_path=.

$(CONFIG_PATH)/model.conf:
	cp test/model.conf $(CONFIG_PATH)/model.conf

$(CONFIG_PATH)/policy.csv:
	cp test/policy.csv $(CONFIG_PATH)/policy.csv

.PHONY: test
test: # Build the project
	@go test -v ./...

.PHONY: format
format: # Format all go code in project
	@gofmt -s -w ./

# Cert gen

.PHONY: init
init: # Initializes the cert config path for Rito
	mkdir -p ${CONFIG_PATH}

.PHONY: gencert
gencert: # Generates ssl certs for Rito server
	cfssl gencert \
		-initca test/ca-csr.json | cfssljson -bare ca
	cfssl gencert \
		-ca=ca.pem \
		-ca-key=ca-key.pem \
		-config=test/ca-config.json \
		-profile=server \
		test/server-csr.json | cfssljson -bare server
	cfssl gencert \
		-ca=ca.pem \
		-ca-key=ca-key.pem \
		-config=test/ca-config.json \
		-profile=client \
		-cn="root" \
		test/client-csr.json | cfssljson -bare root-client
	cfssl gencert \
		-ca=ca.pem \
		-ca-key=ca-key.pem \
		-config=test/ca-config.json \
		-profile=client \
		-cn="nobody" \
		test/client-csr.json | cfssljson -bare nobody-client
	mv *pem *.csr ${CONFIG_PATH}

.PHONY: help
help: # Print valid Make targets
	@echo "Valid targets:"
	@grep --extended-regexp --no-filename '^[a-zA-Z/_-]+:' Makefile | sort | awk 'BEGIN {FS = ":.*?# "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'
