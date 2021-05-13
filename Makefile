REGISTRY ?= hub.docker.io

BUILD_DIR := .build
TEST_DIR := tests
BUILD_SRC := $(subst :,\:, $(sort $(wildcard *.dockerfile)))
BUILD_DST := $(addprefix $(BUILD_DIR)/,$(BUILD_SRC))
BUILD_SRCD := $(shell find root/* 2> /dev/null)
BUILD_DSTD := $(addprefix $(BUILD_DIR)/,$(BUILD_SRCD))
TEST_SRC := $(sort $(wildcard $(TEST_DIR)/*.stch))
TEST_DST :=  $(addprefix $(BUILD_DIR)/,$(TEST_SRC:.stch=))
BUILD_DIRS := $(sort $(dir $(BUILD_DST $(TEST_DST))))

DATE := $(shell date -u +'%Y-%m-%dT%H:%M:%SZ')
REVISION := $(shell git rev-parse --short HEAD 2> /dev/null || printf 0)
SOURCE := $(shell git config --get remote.origin.url 2> /dev/null || printf localhost)

NAMESPACE ?= ""

.PHONY: all clean test test-install

all: build test

clean:
	rm -rf $(BUILD_DIR)

build: qemu $(BUILD_DST) $(TEST_DST)

test:
	docker run -it --rm -v "$$PWD:/src" shellspec/shellspec

# TODO cach
test-install:
	wget -O- https://git.io/shellspec | sh -s -- --yes

qemu:
	docker run --privileged --rm tonistiigi/binfmt --install all

$(BUILD_DIR)/%.dockerfile: %.dockerfile $(BUILD_DSTD) | $(BUILD_DIRS)
	DOCKER_CLI_EXPERIMENTAL=enabled;\
	NAME=$$(basename $< .dockerfile | cut -f 1 -d :);\
	VERSION=$$(basename $< .dockerfile | cut -f 2 -d :);\
	docker buildx build --push\
		--file $<\
		--build-arg DATE="$(DATE)"\
		--build-arg REVISION="$(REVISION)"\
		--build-arg SOURCE="$(SOURCE)"\
		--build-arg VERSION="$$VERSION"\
		--platform linux/amd64,linux/arm64\
 		-t $(NAMESPACE)/$$NAME:$$VERSION . &&\
	touch $@

# Rebuild on any dependency changes
$(BUILD_DSTD): $(BUILD_DIR)/%: % | $(BUILD_DIRS)
	@touch $@

# Rebuild everything on Makefile changes
$(BUILD_SRC) $(BUILD_SRCD) $(TEST_SRC): Makefile
	@touch $@

# Generate build dirs
$(BUILD_DIRS):
	@mkdir -p $@
