.PHONY: docker-build docker-run build clean

VERSION := $(shell git rev-parse --short HEAD 2>/dev/null || echo "latest")
CURDIR := $(CURDIR)

NAME = collection
IMAGE := $(NAME):$(VERSION)
IMAGE_BASE := ghcr.io/anaticulae/$(IMAGE)

docker-build:
	docker build -t $(IMAGE_BASE) .

docker-upload:
	docker push $(IMAGE_BASE)

docker-format: docker-build
	docker run \
	-v $(CURDIR):/var/workdir \
	$(IMAGE_BASE) \
	"cob_format data/"

docker-release: docker-build
	docker run \
	-v $(CURDIR):/var/workdir \
	-e GH_TOKEN=$(GH_TOKEN) $(IMAGE_BASE) \
	"baw release --no_test --no_linter"
