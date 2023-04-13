# Rito: A distribted commit log program

[![Go](https://github.com/briancain/rito/actions/workflows/go.yaml/badge.svg)](https://github.com/briancain/rito/actions/workflows/go.yaml)

Delivering your mail all across accross the Great Sea

## About

Rito is a distributed log server built simply on top of Go. It provides a grpc
API for clients to produce and consume logs via a grpc stream with mutual TLS
to secure traffic between the server and client.
