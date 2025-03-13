# ╔═════════════════════════════════════════════════╗
# ║                  BUILD STAGE                    ║
# ╚═════════════════════════════════════════════════╝
FROM golang:1.23.6-alpine3.20 AS build

# Build the binary
COPY go.mod *.go ./
RUN CGO_ENABLED=0 GOOS=linux go build -o /http-mock


# ╔═════════════════════════════════════════════════╗
# ║               PRODUCTION STAGE                  ║
# ╚═════════════════════════════════════════════════╝
FROM alpine:3.20 AS production

# Create a user to avoid runing as root
RUN adduser -H -D mocker
USER mocker

# Where the input and output files are
WORKDIR /app

# Copy the dependencies
COPY --chown=mocker:mocker --from=build //http-mock /usr/local/bin//http-mock

ENTRYPOINT ["/usr/local/bin//http-mock"]
CMD [ "100", "0" ]
