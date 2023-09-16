package main

import (
	"log"
	"os"
	"os/signal"
	"syscall"
)

var build = "develop"

func main() {
	log.Println("Starting the application...", build)
	defer log.Println("Ending the application...")

	shutdown := make(chan os.Signal, 1)
	signal.Notify(shutdown, syscall.SIGINT, syscall.SIGTERM)
	<-shutdown

	log.Println("Application started. Press CTRL+C to shutdown.")
}
