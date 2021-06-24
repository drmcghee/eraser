FROM golang:1.16 AS build

WORKDIR /src

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -ldflags '-w -extldflags "-static"' -o /out/example .

RUN chmod +x /out/example

FROM scratch as bin

COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

COPY --from=build /out/example /

ENTRYPOINT ["/example"]