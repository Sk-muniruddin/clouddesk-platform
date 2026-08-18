FROM golang:1.26-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -o frontend .

FROM alpine:3.22

WORKDIR /app

COPY --from=builder /app/frontend ./frontend
COPY templates ./templates
COPY static ./static

EXPOSE 8080

CMD ["./frontend"]