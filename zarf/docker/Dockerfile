FROM golang:1.21 AS build_ecomm-api
ENV CGO_ENABLED 0
ARG BUILD_REF

COPY . /go-svc

# Build the admin binary.
WORKDIR /go-svc
RUN go build -ldflags "-X main.build=${BUILD_REF}"


# Run the Go Binary in Alpine.
FROM alpine:3.18
ARG BUILD_DATE
ARG BUILD_REF

COPY --from=build_ecomm-api /go-svc /go-svc/go-svc

WORKDIR /go-svc
CMD ["./go-svc"]

LABEL org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.title="ecomm-api" \
      org.opencontainers.image.authors="Tikaram Mardi <developer@marditech.in>" \
      org.opencontainers.image.source="https://github.com/tikarammardi/go-svc.git" \
      org.opencontainers.image.revision="${BUILD_REF}" \
      org.opencontainers.image.vendor="Mardi Tech"