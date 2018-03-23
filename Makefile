# --- Variables ---

# The project and binary name (without OS and ARCH suffixes):
PROJECT=awscurl

# Use the git tag for the current commit as version or "dev" as fallback:
GET_VERSION=git describe --exact-match --tags 2> /dev/null || echo dev

# Set the version on demand, strip debug symbols and disable DWARF generation:
LD_FLAGS=-X main.Version=$$($(GET_VERSION)) -s -w

# The absolute path for the binary installation:
BIN_PATH = $(GOPATH)/bin/$(PROJECT)

# Dependencies to build the binary:
DEPS = vendor $(PROJECT).go


# --- Main targets ---

# The default target builds binaries for all platforms:
all: $(PROJECT)-linux-amd64 $(PROJECT)-darwin-amd64 $(PROJECT)-windows-386.exe

# Runs the unit tests:
test:
	@go test .

# Installs the binary in $GOPATH/bin/:
install: $(BIN_PATH)

# Deletes the binary from $GOPATH/bin/:
uninstall:
	rm -f $(BIN_PATH)

# Builds the Docker image:
docker:
	docker-compose build

# Releases the binaries on GitHub:
release: all
	./github-release.sh $(PROJECT)-*-*

# Removes all build artifacts:
clean:
	rm -f $(PROJECT)-*-*


# --- Helper targets ---

# Defines phony targets (targets without a corresponding target file):
.PHONY: \
	all \
	test \
	install \
	uninstall \
	docker \
	release \
	clean

# Installs the binary at $GOPATH/bin/:
$(BIN_PATH): $(DEPS)
	go install .

# Install dependencies via `dep ensure` if available, else via `go get`:
vendor:
	if command -v dep > /dev/null 2>&1; then dep ensure; \
		else go get -d ./... && mkdir vendor; fi

# Builds the Linux binary:
$(PROJECT)-linux-amd64: $(DEPS)
	GOOS=linux GOARCH=amd64 go build -ldflags="$(LD_FLAGS)" -o $@ .

# Builds the MacOS binary:
$(PROJECT)-darwin-amd64: $(DEPS)
	GOOS=darwin GOARCH=amd64 go build -ldflags="$(LD_FLAGS)" -o $@ .

# Builds the Windows binary:
$(PROJECT)-windows-386.exe: $(DEPS)
	GOOS=windows GOARCH=386 go build -ldflags="$(LD_FLAGS)" -o $@ .
