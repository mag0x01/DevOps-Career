FROM golang:alpine as app-builder
WORKDIR /demo
COPY . .

RUN go mod download && cd application && go mod tidy && CGO_ENABLED=0 go build . && chmod 700 application
FROM scratch

COPY --from=app-builder /demo/application/application /application
WORKDIR /
ENV APP_HOST 0.0.0.0
ENV APP_PORT 8080
ENTRYPOINT ["./application"]