# syntax=docker.io/docker/dockerfile:1@sha256:9857836c9ee4268391bb5b09f9f157f3c91bb15821bb77969642813b0d00518d

FROM oven/bun:1.2.13-slim@sha256:fb7c5bad6da9573cd637bc1a5ade6602e3bcf5a54988aea874bef5831d3d3fc5 AS base

WORKDIR /app

# Cache packages installation
COPY package.json package.json
COPY bun.lock bun.lock

# for the sake of the prepare script
COPY .husky/ ./.husky/

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

FROM gcr.io/distroless/base:latest@sha256:27769871031f67460f1545a52dfacead6d18a9f197db77110cfc649ca2a91f44

WORKDIR /app

COPY --from=base /app/server server

ENV NODE_ENV=production

CMD ["./server"]

EXPOSE 3000
