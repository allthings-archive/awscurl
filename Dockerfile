FROM golang:1.9-alpine as build
RUN apk --no-cache add git
RUN go get -d -v github.com/allthings/go-aws-auth
WORKDIR /build
COPY awscurl.go .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o awscurl .
ADD https://curl.haxx.se/ca/cacert.pem /etc/ssl/certs/ca-certificates.crt
RUN chmod +r /etc/ssl/certs/ca-certificates.crt

FROM scratch
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build /build/awscurl /bin/
USER 99
ENTRYPOINT ["awscurl"]
