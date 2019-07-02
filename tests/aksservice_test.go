package aks_test

import (
	"fmt"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
	"k8s.io/apimachinery/pkg/api/errors"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	v1 "k8s.io/api/core/v1"
)

var _ = Describe("AKS-Service Tests : ", func() {

		Context("Traefik service", func() {
			service := getService(clientset,"traefik", "admin")
			It("should have loadbalancer ip set", func() {
				Expect(service.Status.LoadBalancer.Ingress[0].IP).ShouldNot(BeNil())
			})
		})

})

func getService(clientset *kubernetes.Clientset, serviceName string, namespace string) (service *v1.Service){

	service , err := clientset.CoreV1().Services(namespace).Get(serviceName, metav1.GetOptions{})
	if errors.IsNotFound(err) {
		fmt.Printf("serviceName %s in namespace %s not found\n", serviceName, namespace)
	} else if statusError, isStatus := err.(*errors.StatusError); isStatus {
		fmt.Printf("Error getting serviceName %s in namespace %s: %v\n",
		serviceName, namespace, statusError.ErrStatus.Message)
	} else if err != nil {
		panic(err.Error())
	} else {
		fmt.Printf("Found serviceName %s in namespace %s\n", serviceName, namespace)
	}
	return service
}
