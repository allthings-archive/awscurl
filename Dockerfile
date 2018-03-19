FROM golang:alpine as build
RUN apk --no-cache add git
RUN go get github.com/golang/dep/cmd/dep
WORKDIR /go/src/github.com/allthings/awscurl
COPY . .
# Install vendored dependencies:
RUN dep ensure
# The program version:
ENV VERSION=latest
# Disable CGO:
ENV CGO_ENABLED=0
# ldflags explanation (see `go tool link`):
#   -s  disable symbol table
#   -w  disable DWARF generation
RUN go build -ldflags="-X main.Version=$VERSION -s -w" -o /bin/awscurl .

FROM scratch
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build /bin/awscurl /bin/
USER 65534
ENTRYPOINT ["awscurl"]
