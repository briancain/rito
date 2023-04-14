package log

import (
	"github.com/hashicorp/raft"
)

type DistributedLog struct {
	config *Config
	log    *Log
	raft   *raft.Raft
}
