FROM golang:1.15.2-alpine3.12

WORKDIR /go/src/paw-accept

COPY go.mod go.sum ./
RUN go mod download

COPY . .
ARG VERSION
ARG COMMIT
ARG DATE
RUN CGO_ENABLED=0 go install -ldflags="-s -w -X main.version=$VERSION -X main.commit=$COMMIT -X main.date=$DATE"

###############################################################################

FROM alpine:3.12.0

COPY --from=0 /go/bin/paw-accept /usr/bin/paw-accept
COPY docker ./docker

CMD ["/bin/sh", "/docker/entry.sh"]

EXPOSE 8080