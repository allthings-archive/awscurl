package main

import (
	"bufio"
	"flag"
	"fmt"
	"io"
	"net/http"
	"os"
	"strings"

	awsauth "github.com/allthings/go-aws-auth"
)

// Version is provided at compile time:
var Version = "dev"

type arrayFlags []string

func (flags *arrayFlags) Set(value string) error {
	*flags = append(*flags, value)
	return nil
}

func (flags *arrayFlags) Iterate() []string {
	return *flags
}

func (flags *arrayFlags) String() string {
	return fmt.Sprint(*flags)
}

func main() {
	var headers arrayFlags
	displayVersion := flag.Bool("v", false, "Display program version")
	requestMethod := flag.String("X", "GET", "HTTP request method")
	data := flag.String("d", "", "HTTP POST data")
	flag.Var(&headers, "H", "HTTP header (key:value)")
	flag.Parse()
	if *displayVersion {
		fmt.Println(Version)
		os.Exit(0)
	}
	args := flag.Args()
	if len(args) == 0 {
		fmt.Println("Error: Missing URL parameter")
		os.Exit(1)
	}
	url := args[0]
	var body io.Reader
	if *data != "" {
		body = strings.NewReader(*data)
	}
	req, err := http.NewRequest(*requestMethod, url, body)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	for _, header := range headers.Iterate() {
		headerParts := strings.Split(header, ":")
		if len(headerParts) != 2 {
			fmt.Println("Error: Invalid header: " + header)
			os.Exit(1)
		}
		req.Header.Add(headerParts[0], headerParts[1])
	}
	awsauth.Sign(req)
	client := new(http.Client)
	response, err := client.Do(req)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	defer response.Body.Close()
	scanner := bufio.NewScanner(response.Body)
	for scanner.Scan() {
		fmt.Println(scanner.Text())
	}
}
