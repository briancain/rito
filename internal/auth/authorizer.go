package auth

import (
	"fmt"

	"github.com/casbin/casbin"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
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

func (a *Authorizer) Authorize(subject, object, action string) error {
	if !a.enforcer.Enforce(subject, object, action) {
		msg := fmt.Sprintf("%q is not permitted to %s to %s",
			subject,
			action,
			object)
		st := status.New(codes.PermissionDenied, msg)
		return st.Err()
	}
	return nil
}
