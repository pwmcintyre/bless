TEST_PATTERN?=.
TEST_OPTIONS?=

GO ?= go

# Install from source.
install:
	@$(GO) install ./cmd/versent-bless/main.go
.PHONY: install

# Run all the tests
test:
	@$(GO) run github.com/pierrre/gotestcover \
		$(TEST_OPTIONS) \
		-covermode=atomic \
		-coverprofile=coverage.txt ./... \
		-run $(TEST_PATTERN) \
		-timeout=2m
.PHONY: test

# Run all the tests and opens the coverage report
cover: test
	@$(GO) tool cover -html=coverage.txt
.PHONY: cover

# Release binaries to GitHub.
release:
	@echo "==> Releasing"
	@$(GO) github.com/goreleaser/goreleaser -p 1 --rm-dist -config .goreleaser.yml
	@echo "==> Complete"
.PHONY: release

generate-mocks:
	@$(GO) go run github.com/vektra/mockery/v2 \
		-dir ../../aws/aws-sdk-go/service/lambda/lambdaiface --all
.PHONY: generate-mocks

.PHONY: test cover generate-mocks
