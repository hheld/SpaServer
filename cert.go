package main

import (
	"crypto/rand"
	"crypto/rsa"
	"crypto/x509"
	"crypto/x509/pkix"
	"encoding/pem"
	"log"
	"math/big"
	"os"
	"time"
)

func init() {
	// check if cert.pem and key.pem exist #############################################################################
	needToGenerateCertificate := false

	if _, err := os.Stat("cert.pem"); os.IsNotExist(err) {
		needToGenerateCertificate = true
	}

	if _, err := os.Stat("key.pem"); os.IsNotExist(err) {
		needToGenerateCertificate = true
	}

	if needToGenerateCertificate == true {
		generateCertificate()
	}
}

// generateCertificate generates a self-sigend certificate. Note that this is for testing only. In production, you
// should use your own certificate from an official CA.
func generateCertificate() {
	rsaBits := 2048
	priv, err := rsa.GenerateKey(rand.Reader, rsaBits)
	if err != nil {
		panic(err)
	}

	notBefore := time.Now()
	notAfter := notBefore.AddDate(1, 0, 0)

	serialNumberLimit := new(big.Int).Lsh(big.NewInt(1), 128)
	serialNumber, err := rand.Int(rand.Reader, serialNumberLimit)
	if err != nil {
		panic("failed to generate serial number: " + err.Error())
	}

	template := x509.Certificate{
		SerialNumber: serialNumber,
		Subject: pkix.Name{
			Organization: []string{"Do it yourself Corp."},
		},
		NotBefore: notBefore,
		NotAfter:  notAfter,

		KeyUsage:              x509.KeyUsageKeyEncipherment | x509.KeyUsageDigitalSignature,
		ExtKeyUsage:           []x509.ExtKeyUsage{x509.ExtKeyUsageServerAuth},
		BasicConstraintsValid: true,
	}

	derBytes, err := x509.CreateCertificate(rand.Reader, &template, &template, &priv.PublicKey, priv)
	if err != nil {
		panic("Failed to create certificate: " + err.Error())
	}

	certOut, err := os.Create("cert.pem")
	if err != nil {
		panic("Failed to open cert.pem for writing: " + err.Error())
	}
	pem.Encode(certOut, &pem.Block{Type: "CERTIFICATE", Bytes: derBytes})
	certOut.Close()
	log.Print("Written cert.pem\n")

	keyOut, err := os.OpenFile("key.pem", os.O_WRONLY|os.O_CREATE|os.O_TRUNC, 0600)
	if err != nil {
		panic("Failed to open key.pem for writing: " + err.Error())
	}
	pem.Encode(keyOut, &pem.Block{Type: "RSA PRIVATE KEY", Bytes: x509.MarshalPKCS1PrivateKey(priv)})
	keyOut.Close()
	log.Print("Written key.pem\n")
}
