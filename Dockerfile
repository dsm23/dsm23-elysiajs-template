# syntax=docker.io/docker/dockerfile:1@sha256:4a43a54dd1fedceb30ba47e76cfcf2b47304f4161c0caeac2db1c61804ea3c91

FROM oven/bun:1.3.10-slim@sha256:5d5863f35ad9b3acceee8dc134fb2b89f07831129eaeec81af2b19a23dabe3e0 AS base

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

FROM gcr.io/distroless/base:latest@sha256:b0510424f0c7c1d6fdae75ef5c1d349fa72d312e96f69728fad6beb04755b8b4

WORKDIR /app

COPY --from=base /app/server server

ENV NODE_ENV=production

CMD ["./server"]

EXPOSE 3000
