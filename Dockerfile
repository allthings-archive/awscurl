FROM golang:alpine as build
# Install git, which is required to install the package dependencies:
RUN apk --no-cache add git
WORKDIR /build
COPY awscurl.go .
# Install dependencies:
RUN go get -d ./...
# The program version:
ENV VERSION=latest
# Compile for Linux 64bit architecture:
ENV GOOS=linux GOARCH=amd64
# Disable CGO:
ENV CGO_ENABLED=0
# ldflags explanation (see `go tool link`):
#   -X definition
#       add string value definition of the form importpath.name=value
#   -s  disable symbol table
#   -w  disable DWARF generation
RUN go build -ldflags="-X main.Version=$VERSION -s -w" -o awscurl .
ADD https://curl.haxx.se/ca/cacert.pem ca-certificates.crt
RUN chmod +r ca-certificates.crt

FROM scratch
COPY --from=build /build/ca-certificates.crt /etc/ssl/certs/
COPY --from=build /build/awscurl /bin/
USER 65534
ENTRYPOINT ["awscurl"]
