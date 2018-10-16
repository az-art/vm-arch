ARCH_PACKER_TEMPLATE=archlinux-x86_64.json
ARGS=
#ARGS=-var compression_level=0 -var disk_size=4000

.PHONY: all build publish help

.DEFAULT_GOAL := default

default: help ;

all: build test publish clean

validate:
	${INFO} "Validating packer image... $(ARCH_PACKER_TEMPLATE)"
	@ packer validate $(ARCH_PACKER_TEMPLATE)

build: validate
	${INFO} "Building packer image... $(ARCH_PACKER_TEMPLATE) with ARGS:$(ARGS)"
	@ packer build $(ARGS) $(ARCH_PACKER_TEMPLATE)

up:
	${INFO} "Starting up VM $(ARCH_PACKER_TEMPLATE)"
	${CHECK_IMAGE} "$(IMAGE_NAME):$(BRANCH)"
	${INFO} "Image OK"

destroy:
	${INFO} "Starting up packer image... $(ARCH_PACKER_TEMPLATE) with ARGS:$(ARGS)"
	${CHECK_IMAGE} "$(IMAGE_NAME):$(BRANCH)"
	${INFO} "Image OK"

provision:
	${INFO} "Starting up packer image... $(ARCH_PACKER_TEMPLATE) with ARGS:$(ARGS)"
	${CHECK_IMAGE} "$(IMAGE_NAME):$(BRANCH)"
	${INFO} "Image OK"

clean:
	${INFO} "Cleaning up ..."
	@ docker images --filter=reference='$(IMAGE_NAME)' -q | xargs -r docker rmi -f

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
