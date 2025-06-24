FROM golang:1.22-alpine AS builder
WORKDIR /app
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o service1 main.go


FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/service1 .
EXPOSE 8001
CMD ["./service1"]
