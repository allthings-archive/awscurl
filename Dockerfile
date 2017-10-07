FROM golang:1.9-alpine as build
RUN apk --no-cache add git
WORKDIR /build
COPY awscurl.go .
RUN go get -d ./...
ENV CGO_ENABLED=0 GOOS=linux LDFLAGS='-X main.Version=latest -s -w'
RUN go build -a -installsuffix cgo -o awscurl -ldflags="$LDFLAGS" .
ADD https://curl.haxx.se/ca/cacert.pem /etc/ssl/certs/ca-certificates.crt
RUN chmod +r /etc/ssl/certs/ca-certificates.crt

FROM scratch
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build /build/awscurl /bin/
USER 99
ENTRYPOINT ["awscurl"]
