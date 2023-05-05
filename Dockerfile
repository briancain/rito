FROM golang:1.19-alpine

RUN mkdir -p /tmp/rito
COPY . /tmp/rito

WORKDIR /tmp/rito

# Download Go modules
RUN go mod download

# Build
RUN CGO_ENABLED=0 GOOS=linux go build -o ./rito ./cmd/rito

ENTRYPOINT ["/rito"]
