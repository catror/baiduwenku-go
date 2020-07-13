FROM golang:alpine AS builder

ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64 \
    GOPROXY="https://goproxy.io"

WORKDIR /build

COPY . .
RUN go mod download
RUN go build -o app .

FROM scratch
#拷贝证书，否则无法进行https请求
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /build/app /
COPY front-end /front-end
EXPOSE 9898

CMD ["/app"]