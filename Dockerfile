FROM golang:1.14.2-alpine as build

WORKDIR /go/app

COPY . .

ENV GO111MODULE=off

RUN set -ex \
    && apk update \
    && apk add --no-cache git curl \
    && curl -fLo /go/bin/air https://git.io/linux_air \
    && chmod +x /go/bin/air \
    && go get -u -v github.com/go-delve/delve/cmd/dlv

ENV GO111MODULE=on

RUN set -ex \
    && go build -o build/api

FROM alpine

WORKDIR /app

ENV APP_ENV=production

COPY --from=build /go/app/build/api .
COPY --from=build /go/app/configs/dbconf.yml ./configs/

RUN addgroup go \
    && adduser -D -G go go \
    && chown -R go:go /app/api \
    && chown -R go:go /app/configs/dbconf.yml

CMD ["./api"]