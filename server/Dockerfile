# ShopBandit server: official PocketBase release binary (pinned + checksum) with
# the ShopBandit migrations and hooks baked in.
FROM alpine:3.22 AS download
ARG PB_VERSION=0.40.5
ARG TARGETARCH
# sha256 from https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/checksums.txt
ARG PB_SHA256_amd64=1dbea1b01eb3dfe64953513859d01e759c96650c4e3264fa4eecd54b769382e4
ARG PB_SHA256_arm64=570baa1c45d2fb92fc0073582b945ca0ece03cbf9837ccabf49a222f99dd02e3
RUN apk add --no-cache curl unzip \
 && curl -fsSL -o /tmp/pb.zip "https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_${TARGETARCH}.zip" \
 && eval "SUM=\$PB_SHA256_${TARGETARCH}" \
 && echo "${SUM}  /tmp/pb.zip" | sha256sum -c - \
 && unzip -q /tmp/pb.zip pocketbase -d /out

FROM alpine:3.22
RUN apk add --no-cache ca-certificates tzdata wget \
 && adduser -D -H -u 10001 pocketbase \
 && mkdir -p /pb/pb_data && chown pocketbase /pb/pb_data
COPY --from=download /out/pocketbase /pb/pocketbase
COPY pb_migrations /pb/pb_migrations
COPY pb_hooks /pb/pb_hooks
USER pocketbase
WORKDIR /pb
VOLUME /pb/pb_data
EXPOSE 8090
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s \
  CMD wget -qO- http://127.0.0.1:8090/api/health >/dev/null || exit 1
ENTRYPOINT ["/pb/pocketbase"]
CMD ["serve", "--http=0.0.0.0:8090", "--dir=/pb/pb_data", "--migrationsDir=/pb/pb_migrations", "--hooksDir=/pb/pb_hooks"]
