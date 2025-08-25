# syntax=docker.io/docker/dockerfile:1@sha256:38387523653efa0039f8e1c89bb74a30504e76ee9f565e25c9a09841f9427b05

FROM oven/bun:1.2.21-slim@sha256:9759e7229cd7c2939d960420bdb8dc5dc3b3dda0285f8601226606e5fd97dfdf AS base

WORKDIR /app

# Cache packages installation
COPY package.json package.json
COPY bun.lock bun.lock

RUN bun install --frozen-lockfile

COPY ./src ./src

ENV NODE_ENV=production

RUN bun build \
	--compile \
	--minify-whitespace \
	--minify-syntax \
	--target bun \
	--outfile server \
	./src/index.ts

FROM gcr.io/distroless/base:latest@sha256:4f6e739881403e7d50f52a4e574c4e3c88266031fd555303ee2f1ba262523d6a

WORKDIR /app

COPY --from=base /app/server server

ENV NODE_ENV=production

CMD ["./server"]

EXPOSE 3000
