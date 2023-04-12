package auth

import (
	"github.com/casbin/casbin"
)

type Authorizer struct {
	enforcer *casbin.Enforcer
}

func New(model, policy string) *Authorizer {
	e := casbin.NewEnforcer(model, policy)
	return &Authorizer{
		enforcer: e,
	}
}
