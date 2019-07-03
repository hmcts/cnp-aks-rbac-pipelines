package aks_test

import (
	"testing"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
	"github.com/onsi/ginkgo/reporters"
)

func TestAKS(t *testing.T) {
	RegisterFailHandler(Fail)
	junitReporter := reporters.NewJUnitReporter("AKSTestResult.xml")
    RunSpecsWithDefaultAndCustomReporters(t, "AKS Test Suite", []Reporter{junitReporter})
}
