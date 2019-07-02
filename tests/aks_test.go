package aks_test

import (
	"flag"
	"fmt"
	"os"
	"path/filepath"
	"time"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
	"k8s.io/apimachinery/pkg/api/errors"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	v1 "k8s.io/api/apps/v1"
	"k8s.io/client-go/tools/clientcmd"
	_ "k8s.io/client-go/plugin/pkg/client/auth/azure"
)

var _ = Describe("AKS-Pipeline Tests : ", func() {
	//Adding delay just to let flux deploy the manifests.
	time.Sleep(30 * time.Second)
	
	   clientset := getClientSet()

		Context("Flux deployment is running", func() {
			deployment := getDeployment(clientset,"flux", "admin")
			It("should be having atleast 1 replica", func() {
				Expect(deployment.Status.ReadyReplicas).To(
					BeNumerically(">", 0))
			})
		})

		Context("Sealed Secrets deployment is running", func() {
			deployment := getDeployment(clientset,"sealed-secrets", "admin")
			It("should be having atleast 1 replica", func() {
				Expect(deployment.Status.ReadyReplicas).To(
					BeNumerically(">", 0))
			})
			_, err := clientset.CoreV1().Secrets("admin").Get("fluxcloud-values", metav1.GetOptions{})
			It("should be having fluxcloud-values secret", func() {
				Expect(err).ShouldNot(HaveOccurred())
			})

		})

		Context("traefik deployment is running", func() {
			deployment := getDeployment(clientset,"traefik", "admin")
			It("should be having atleast 1 replica", func() {
				Expect(deployment.Status.ReadyReplicas).To(
					BeNumerically(">", 0))
			})
		})

})

func homeDir() string {
	if h := os.Getenv("HOME"); h != "" {
		return h
	}
	return os.Getenv("USERPROFILE") // windows
}

func getClientSet() *kubernetes.Clientset{
	var kubeconfig *string
	if home := homeDir(); home != "" {
		kubeconfig = flag.String("kubeconfig", filepath.Join(home, ".kube", "config"), "(optional) absolute path to the kubeconfig file")
	} else {
		panic("Unable to Find Home Dir")
	}
	flag.Parse()

	// use the current context in kubeconfig
	config, err := clientcmd.BuildConfigFromFlags("", *kubeconfig)
	if err != nil {
		panic(err.Error())
	}

	// create the clientset
	clientset, err := kubernetes.NewForConfig(config)
	if err != nil {
		panic(err.Error())
	}
	return clientset
}

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
