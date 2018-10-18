ARCH_PACKER_TEMPLATE=archlinux-x86_64.json
ARCH_BOX_FILE=archlinux-x86_64-virtualbox.box
ARCH_BOX_NAME=arch
ARGS=
#ARGS=-var compression_level=0 -var disk_size=4000

.PHONY: all build publish help

.DEFAULT_GOAL := default

default: help ;

all: build register clean

validate:
	${INFO} "Validating packer image... [$(ARCH_PACKER_TEMPLATE)]"
	@ packer validate $(ARCH_PACKER_TEMPLATE)

build: validate
	${INFO} "Building packer image... [$(ARCH_PACKER_TEMPLATE)] with [ARGS:$(ARGS)]"
	@ packer build $(ARGS) $(ARCH_PACKER_TEMPLATE)

register:
	${INFO} "Registering box... [$(ARCH_BOX_NAME)] from [$(ARCH_BOX_FILE)] file."
	@ -vagrant box remove $(ARCH_BOX_NAME)
	@ vagrant box add $(ARCH_BOX_NAME) $(ARCH_BOX_FILE)
	@ vagrant box list

up:
	${INFO} "Starting up VM [$(ARCH_BOX_NAME)]"
	@vagrant up

destroy:
	${INFO} "Destroying [$(ARCH_BOX_NAME)] virtual machine."
	@vagrant destroy -f

provision:
	${INFO} "Provisioning... [$(ARCH_BOX_NAME)]."
	@vagrant reload --provision

clean:
	${INFO} "Cleaning up ..."
	@ docker images --filter=reference='$(IMAGE_NAME)' -q | xargs -r docker rmi -f

help:
	${INFO} "-----------------------------------------------------------------------"
	${INFO} "                      Available commands                              -"
	${INFO} "-----------------------------------------------------------------------"
	${INFO} "   > validate - Validate Packer template."
	${INFO} "   > build - Build Packer box."
	${INFO} "   > register - Register Packer box as Vagrant box."
	${INFO} "   > destroy - Destroy VM."
	${INFO} "   > provision - Provision VM."
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
