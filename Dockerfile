FROM golang:1.24 AS builder

WORKDIR /root/karpenter-provider-aws
COPY . .
RUN CGO_ENABLED=0 go build -a -trimpath -ldflags="-extldflags=-static -s -w" -o karpenter ./cmd/controller/main.go

FROM gcr.io/distroless/static:nonroot
COPY --from=builder /root/karpenter-provider-aws/karpenter /usr/bin/karpenter
USER 65532:65532

ENTRYPOINT ["/usr/bin/karpenter"]
