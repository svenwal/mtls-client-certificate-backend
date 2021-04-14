package main

import (
	"crypto/tls"
	"crypto/x509"
	"encoding/json"
	"io/ioutil"
	"log"
	"net/http"
	"path/filepath"
)

type Answer struct {
	Name      string
	Functions []string
}

func HelloServer(w http.ResponseWriter, req *http.Request) {
	w.Header().Set("Content-Type", "text/plain")
	w.Write([]byte("Hello from test server.\n"))
}

func handleError(err error) {
	if err != nil {
		log.Fatal("Fatal", err)
	}
}

func main() {
	absPathServerCrt, err := filepath.Abs("certs/ca/ca.cert.pem")
	handleError(err)
	absPathServerKey, err := filepath.Abs("certs/ca/private/ca.key.unencrypted.pem")
	handleError(err)

	clientCACert, err := ioutil.ReadFile(absPathServerCrt)
	handleError(err)

	clientCertPool := x509.NewCertPool()
	clientCertPool.AppendCertsFromPEM(clientCACert)

	tlsConfig := &tls.Config{
		ClientAuth:               tls.RequireAndVerifyClientCert,
		ClientCAs:                clientCertPool,
		PreferServerCipherSuites: true,
		MinVersion:               tls.VersionTLS12,
	}

	tlsConfig.BuildNameToCertificate()

	http.HandleFunc("/", JsonServer)
	httpServer := &http.Server{
		Addr:      ":443",
		TLSConfig: tlsConfig,
	}

	err = httpServer.ListenAndServeTLS(absPathServerCrt, absPathServerKey)
	handleError(err)
}

func JsonServer(w http.ResponseWriter, r *http.Request) {
	profile := Answer{"Konnect Enterprise", []string{"Gateway", "Manager", "Developer Portal", "Vitals", "Immunity", "Mesh"}}

	js, err := json.Marshal(profile)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.Write(js)
}
