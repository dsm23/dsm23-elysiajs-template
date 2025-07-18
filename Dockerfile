# syntax=docker.io/docker/dockerfile:1@sha256:9857836c9ee4268391bb5b09f9f157f3c91bb15821bb77969642813b0d00518d

FROM oven/bun:1.2.19-slim@sha256:743076beabe067f7cb54909d12f6873638a77cd032d522142cbfa5263c0cfeb9 AS base

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

FROM gcr.io/distroless/base:latest@sha256:201ef9125ff3f55fda8e0697eff0b3ce9078366503ef066653635a3ac3ed9c26

WORKDIR /app

COPY --from=base /app/server server

ENV NODE_ENV=production

CMD ["./server"]

EXPOSE 3000
