.PHONY: all image build interactive

CONTAINER_RUNTIME ?= /usr/bin/crun

all: build

image:
	podman build \
		--runtime="$(CONTAINER_RUNTIME)" \
		-t build-headscale \
		-f Containerfile \
			container

image-from-scratch:
	podman build \
		--runtime="$(CONTAINER_RUNTIME)" \
		-t build-headscale \
		--no-cache \
		-f Containerfile \
			container

build-from-scratch: image-from-scratch
	mkdir -p /tmp/build-headscale/out
	podman run -it --rm \
		--runtime="$(CONTAINER_RUNTIME)" \
		-v "/tmp/build-headscale/out:/out" \
		--env-file .env \
			build-headscale

interactive-from-scratch: image-from-scratch
	mkdir -p /tmp/build-headscale/out
	podman run -it --rm \
		--runtime="$(CONTAINER_RUNTIME)" \
		-v "/tmp/build-headscale/out:/out" \
		--env-file .env \
		--entrypoint bash \
			build-headscale

build: image
	mkdir -p /tmp/build-headscale/out
	podman run -it --rm \
		--runtime="$(CONTAINER_RUNTIME)" \
		-v "/tmp/build-headscale/out:/out" \
		--env-file .env \
			build-headscale

interactive: image
	mkdir -p /tmp/build-headscale/out
	podman run -it --rm \
		--runtime="$(CONTAINER_RUNTIME)" \
		-v "/tmp/build-headscale/out:/out" \
		--env-file .env \
		--entrypoint bash \
			build-headscale

help:
	grep '^[a-zA-Z\-_0-9].*:' Makefile | cut -d : -f 1 | sort
