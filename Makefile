# The binary name (without OS and ARCH suffixes):
BIN=awscurl
# Use the git tag for the current commit as version or "dev" as fallback:
VERSION=$(shell git describe --exact-match --tags 2> /dev/null || echo dev)
# Set the version, strip debug symbols and disable DWARF generation:
FLAGS=-X main.Version=$(VERSION) -s -w
# List all go source files, used to determine if make needs to rebuild targets:
SRC=$(shell find . -name '*.go')
# Determine the dependencies excluding those from the standard library:
DEPS=$(shell \
(go list -f '{{join .Deps "\n"}}' .;go list std;go list std) \
| sort | uniq -u | sed -e 's|^|$(GOPATH)/src/|;s| |\\&|g')

all: $(BIN)-linux-amd64 $(BIN)-darwin-amd64 $(BIN)-windows-386.exe

$(DEPS):
	go get -d ./...

$(BIN)-linux-amd64: $(DEPS) $(SRC)
	GOOS=linux GOARCH=amd64 go build -o $@ -ldflags="$(FLAGS)" .

$(BIN)-darwin-amd64: $(DEPS) $(SRC)
	GOOS=darwin GOARCH=amd64 go build -o $@ -ldflags="$(FLAGS)" .

$(BIN)-windows-386.exe: $(DEPS) $(SRC)
	GOOS=windows GOARCH=386 go build -o $@ -ldflags="$(FLAGS)" .

clean:
	rm -f $(BIN)-*-*
