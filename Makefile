# Project variables
DOCKER_REGISTRY_HOST ?= registry.corp.globoforce.com
PROJECT ?= globoforce
CURRENT_DIR ?= $(shell basename `pwd`)
BRANCH ?= TRUNK-SNAPSHOT
NEXUS_HOST ?= http://10.40.22.40:8081/nexus
IMAGE_NAME ?= $(DOCKER_REGISTRY_HOST)/$(PROJECT)/$(CURRENT_DIR)
ARGS=--build-arg BRANCH=$(BRANCH) --build-arg NEXUS_HOST=$(NEXUS_HOST)

.PHONY: all build publish help

.DEFAULT_GOAL := default

default: help ;

all: build test publish clean

build:
	${INFO} "Building image... $(IMAGE_NAME):$(BRANCH) with ARGS:$(ARGS)"
	@ docker build -t $(IMAGE_NAME):$(BRANCH) --no-cache $(ARGS) .

test:
	${INFO} "Testing image... $(IMAGE_NAME):$(BRANCH)"
	${CHECK_IMAGE} "$(IMAGE_NAME):$(BRANCH)"
	${INFO} "Image OK"

publish: login
	${INFO} "Publishing image... $(IMAGE_NAME):$(BRANCH)"
	@docker push $(IMAGE_NAME):$(BRANCH)
	${INFO} "Publish complete"

login:
	${INFO} "Logging in to Docker registry $(DOCKER_REGISTRY_HOST)..."
	@ docker login $(DOCKER_REGISTRY_HOST) -u ${GF_REGISTRY_USER} -p ${GF_REGISTRY_PASS}
	${INFO} "Logged in to Docker registry $(DOCKER_REGISTRY_HOST)"

clean:
	${INFO} "Cleaning up images..."
	@docker images --filter=reference='$(IMAGE_NAME)' -q | xargs -r docker rmi -f

help:
	${INFO} "-----------------------------------------------------------------------"
	${INFO} "                      Available commands                              -"
	${INFO} "-----------------------------------------------------------------------"
	${INFO} "   > build - To build $(CURRENT_DIR) image."
	${INFO} "   > publish - To publish $(CURRENT_DIR) image."
	${INFO} "   > clean - To cleanup images."
	${INFO} "   > all - To execute all steps."
	${INFO} "   > help - To see this help."
	${INFO} "-----------------------------------------------------------------------"

# Cosmetics
RED := "\e[1;31m"
YELLOW := "\e[1;33m"
NC := "\e[0m"

# Shell Functions
INFO := @bash -c '\
  printf $(YELLOW); \
  echo "=> $$1"; \
  printf $(NC)' SOME_VALUE

CHECK_IMAGE := @bash -c '\
  if ! docker inspect "$$1"; then\
  printf $(RED); \
  echo "=> $$1 does not exist!"; \
  printf $(NC); \
  exit 1; \
  fi' SOME_VALUE
