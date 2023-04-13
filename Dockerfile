FROM golang:1.19-apline as BUILD
WORKDIR /go/src/rito
COPY . .
RUN CGO_ENABLED=0 go build -o /go/bin/rito ./cmd/rito

FROM scratch
COPY --from=build /go/bin/rito /bin/rito
ENTRYPOINT ["bin/rito"]
