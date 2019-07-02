package aks_test

import (
	"fmt"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
	"k8s.io/apimachinery/pkg/api/errors"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	v1 "k8s.io/api/apps/v1"
)

var _ = Describe("AKS-Deployment Tests : ", func() {

		Context("Flux deployment is running", func() {
			deployment := getDeployment(clientset,"flux", "admin")
			It("should have at least 1 replica", func() {
				Expect(deployment.Status.ReadyReplicas).To(
					BeNumerically(">", 0))
			})
		})

		Context("Sealed Secrets deployment is running", func() {
			deployment := getDeployment(clientset,"sealed-secrets", "admin")
			It("should have at least 1 replica", func() {
				Expect(deployment.Status.ReadyReplicas).To(
					BeNumerically(">", 0))
			})
			_, err := clientset.CoreV1().Secrets("admin").Get("fluxcloud-values", metav1.GetOptions{})
			It("should have fluxcloud-values secret", func() {
				Expect(err).ShouldNot(HaveOccurred())
			})

		})

		Context("traefik deployment is running", func() {
			deployment := getDeployment(clientset,"traefik", "admin")
			It("should have at least 1 replica", func() {
				Expect(deployment.Status.ReadyReplicas).To(
					BeNumerically(">", 0))
			})
		})

})

func getDeployment(clientset *kubernetes.Clientset, deploymentName string, namespace string) (deployment *v1.Deployment){

	deployment , err := clientset.AppsV1().Deployments(namespace).Get(deploymentName, metav1.GetOptions{})
	if errors.IsNotFound(err) {
		fmt.Printf("deploymentName %s in namespace %s not found\n", deploymentName, namespace)
	} else if statusError, isStatus := err.(*errors.StatusError); isStatus {
		fmt.Printf("Error getting deploymentName %s in namespace %s: %v\n",
		deploymentName, namespace, statusError.ErrStatus.Message)
	} else if err != nil {
		panic(err.Error())
	} else {
		fmt.Printf("Found deploymentName %s in namespace %s\n", deploymentName, namespace)
	}
	return deployment
}
