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

.PHONY: run
run: # Build the project
	./bin/waypoint-station

.PHONY: format
format: # Format all go code in project
	@gofmt -s -w ./

.PHONY: help
help: # Print valid Make targets
	@echo "Valid targets:"
	@grep --extended-regexp --no-filename '^[a-zA-Z/_-]+:' Makefile | sort | awk 'BEGIN {FS = ":.*?# "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'
