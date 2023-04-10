package server

import (
	"fmt"
	"sync"
)

type Log struct {
	mu      sync.Mutex
	records []Record
}

type Record struct {
	Value  []byte `json:"value"`
	Offset uint64 `json:"offset"`
}

func NewLog() *Log {
	return &Log{}
}

var ErrOffsetNotFound = fmt.Errorf("offset not found")

func (c *Log) Append(record Record) (uint64, error) {
	return 0, nil
}

func (c *Log) Read(offset uint64) (Record, error) {
	return Record{}, nil
}
