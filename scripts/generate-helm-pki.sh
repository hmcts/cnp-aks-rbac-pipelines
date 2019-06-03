#!/bin/bash
set -e

VAULT_NAME=$1

openssl genrsa -out ./ca.key.pem 4096

openssl req -key ca.key.pem -new -x509 -days 7300 -sha256 \
-out ca.cert.pem -extensions v3_ca \
-subj "/C=GB/ST=London/L=London/O=Ministry of Justice/OU=HMCTS/CN=helm.platform.hmcts.net" -nodes

openssl genrsa -out ./tiller.key.pem 4096

openssl genrsa -out ./helm.key.pem 4096

openssl req -key tiller.key.pem -new -sha256 -out tiller.csr.pem \
-subj "/C=GB/ST=London/L=London/O=Ministry of Justice/OU=HMCTS/CN=helm.platform.hmcts.net" -nodes

openssl req -key helm.key.pem -new -sha256 -out helm.csr.pem \
-subj "/C=GB/ST=London/L=London/O=Ministry of Justice/OU=HMCTS/CN=helm.platform.hmcts.net" -nodes

echo subjectAltName=IP:127.0.0.1 > extfile.cnf

openssl x509 -req -CA ca.cert.pem -CAkey ca.key.pem -CAcreateserial \
-in tiller.csr.pem -out tiller.cert.pem -days 365 -extfile extfile.cnf

openssl x509 -req -CA ca.cert.pem -CAkey ca.key.pem -CAcreateserial \
-in helm.csr.pem -out helm.cert.pem -days 365

# Generate secret for Helm certs for Flux while we're at it
kubectl -n admin create secret tls helm-client-certs \
--cert=helm.cert.pem \
--key=helm.key.pem \
--dry-run -o yaml > helm-client-certs.yaml

function set_kv_secret {
 az keyvault secret set \
 --vault-name ${VAULT_NAME} \
 --encoding ascii \
 --name ${1} \
 --file ${2} \
 --description "${3}"
}

set_kv_secret helm-pki-ca-key      ca.key.pem             "Helm PKI CA private key"
set_kv_secret helm-pki-ca-cert     ca.cert.pem            "Helm PKI CA certificate"
set_kv_secret helm-pki-tiller-key  tiller.key.pem         "Helm PKI Tiller private key"
set_kv_secret helm-pki-helm-key    helm.key.pem           "Helm PKI Helm private key"
set_kv_secret helm-pki-tiller-csr  tiller.csr.pem         "Helm PKI Tiller CSR"
set_kv_secret helm-pki-helm-csr    helm.csr.pem           "Helm PKI Helm CSR"
set_kv_secret helm-pki-tiller-cert tiller.cert.pem        "Helm PKI Tiller certificate"
set_kv_secret helm-pki-helm-cert   helm.cert.pem          "Helm PKI Helm certificate"
set_kv_secret helm-pki-flux-secret helm-client-certs.yaml "Helm PKI Flux Secret"

# Just to allow re-downloading later - may not need
rm *.pem helm-client-certs.yaml
