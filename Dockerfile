# syntax=docker.io/docker/dockerfile:1@sha256:dabfc0969b935b2080555ace70ee69a5261af8a8f1b4df97b9e7fbcf6722eddf

FROM oven/bun:1.2.22-slim@sha256:565aef85d12081f23556518b9197aaf7470c3c4fef9c20c1dad47b7214568a9e AS base

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

FROM gcr.io/distroless/base:latest@sha256:fa15492938650e1a5b87e34d47dc7d99a2b4e8aefd81b931b3f3eb6bb4c1d2f6

WORKDIR /app

COPY --from=base /app/server server

ENV NODE_ENV=production

CMD ["./server"]

EXPOSE 3000
