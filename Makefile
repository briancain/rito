CONFIG_PATH=${HOME}/.rito/

.PHONY: build
build: # Build the project
	@go build -o bin/ ./...

.PHONY: proto
proto: # Generates the protobufs
	@protoc api/v1/*.proto \
		--go_out=. \
		--go-grpc_out=. \
		--go_opt=paths=source_relative \
		--go-grpc_opt=paths=source_relative \
		--proto_path=.

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
		test/client-csr.json | cfssljson -bare client
	mv *pem *.csr ${CONFIG_PATH}

.PHONY: help
help: # Print valid Make targets
	@echo "Valid targets:"
	@grep --extended-regexp --no-filename '^[a-zA-Z/_-]+:' Makefile | sort | awk 'BEGIN {FS = ":.*?# "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'
