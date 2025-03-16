fix:
	cargo machete --fix || true
	cargo +nightly fmt
	cargo clippy --fix --allow-dirty --allow-staged

fix-ui:
	pnpm lint:fix

update-ui:
	pnpm build
	rm -rf ee/tabby-webserver/ui && cp -R ee/tabby-ui/out ee/tabby-webserver/ui
	rm -rf ee/tabby-webserver/email_templates && cp -R ee/tabby-email/out ee/tabby-webserver/email_templates

update-db-schema:
	sqlite3 ee/tabby-db/schema.sqlite ".schema --indent" > ee/tabby-db/schema/schema.sql
	sqlite3 ee/tabby-db/schema.sqlite -init  ee/tabby-db/schema/sqlite-schema-visualize.sql "" > schema.dot
	dot -Tsvg schema.dot > ee/tabby-db/schema/schema.svg
	rm schema.dot

dev:
	tmuxinator start -p .tmuxinator/tabby.yml
		
bump-version:
	cargo ws version --force "*" --no-individual-tags --allow-branch "main"

bump-release-version:
	cargo ws version --allow-branch "r*" --no-individual-tags --force "*"

update-openapi-doc:
	curl http://localhost:8080/api-docs/openapi.json | jq '                                                       \
	delpaths([                                                                                                    \
		  ["paths", "/v1beta/chat/completions"],                                                                  \
		  ["paths", "/v1beta/search"],                                                                            \
		  ["paths", "/v1beta/server_setting"],                                                                    \
		  ["components", "schemas", "CompletionRequest", "properties", "prompt"],                                 \
		  ["components", "schemas", "CompletionRequest", "properties", "debug_options"],                          \
		  ["components", "schemas", "CompletionResponse", "properties", "debug_data"],                            \
		  ["components", "schemas", "DebugData"],                                                                 \
		  ["components", "schemas", "DebugOptions"],                                                              \
		  ["components", "schemas", "ServerSetting"]                                                              \
	  ])' | jq '.servers[0] |= { url: "https://playground.app.tabbyml.com", description: "Playground server" }'   \
			    > website/static/openapi.json

update-graphql-schema:
	cargo run --package tabby-schema --example update-schema --features=schema-language

# CMake and Ninja build targets
cmake-prepare:
	mkdir -p .cmake build

cmake-verify: cmake-prepare
	@if [ -x "$(shell command -v bash)" ]; then \
		bash ./scripts/build_cmake.sh --verify; \
	elif [ -x "$(shell command -v pwsh)" ] || [ -x "$(shell command -v powershell)" ]; then \
		powershell -ExecutionPolicy Bypass -File ./scripts/build_cmake.ps1 --verify; \
	else \
		echo "Error: Neither bash nor PowerShell found"; \
		exit 1; \
	fi

cmake-build: cmake-prepare
	@if [ -x "$(shell command -v bash)" ]; then \
		cores=$$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4); \
		bash ./scripts/build_cmake.sh --parallel=$$cores; \
	elif [ -x "$(shell command -v pwsh)" ] || [ -x "$(shell command -v powershell)" ]; then \
		powershell -ExecutionPolicy Bypass -File ./scripts/build_cmake.ps1; \
	else \
		echo "Error: Neither bash nor PowerShell found"; \
		exit 1; \
	fi

cmake-build-parallel: cmake-prepare
	@if [ -x "$(shell command -v bash)" ]; then \
		cores=$$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4); \
		max_cores=$$((cores * 2)); \
		echo "Building with $$max_cores parallel jobs"; \
		bash ./scripts/build_cmake.sh --parallel=$$max_cores; \
	elif [ -x "$(shell command -v pwsh)" ] || [ -x "$(shell command -v powershell)" ]; then \
		powershell -ExecutionPolicy Bypass -File "$(shell pwd)/scripts/pwsh_parallel_build.ps1"; \
	else \
		echo "Error: Neither bash nor PowerShell found"; \
		exit 1; \
	fi

cmake-build-cuda: cmake-prepare
	@if [ -x "$(shell command -v bash)" ]; then \
		cores=$$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4); \
		bash ./scripts/build_cmake.sh --cuda --parallel=$$cores; \
	elif [ -x "$(shell command -v pwsh)" ] || [ -x "$(shell command -v powershell)" ]; then \
		powershell -ExecutionPolicy Bypass -File ./scripts/build_cmake.ps1 --cuda; \
	else \
		echo "Error: Neither bash nor PowerShell found"; \
		exit 1; \
	fi

cmake-build-rocm: cmake-prepare
	@if [ -x "$(shell command -v bash)" ]; then \
		cores=$$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4); \
		bash ./scripts/build_cmake.sh --rocm --parallel=$$cores; \
	else \
		echo "Error: ROCm builds are not supported on Windows"; \
		exit 1; \
	fi

cmake-build-metal: cmake-prepare
	@if [ -x "$(shell command -v bash)" ]; then \
		cores=$$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4); \
		bash ./scripts/build_cmake.sh --metal --parallel=$$cores; \
	else \
		echo "Error: Metal builds are not supported on Windows"; \
		exit 1; \
	fi

cmake-clean:
	rm -rf build/cmake-*

.PHONY: fix fix-ui update-ui update-db-schema dev bump-version bump-release-version \
	update-openapi-doc update-graphql-schema cmake-prepare cmake-verify cmake-build cmake-build-parallel \
	cmake-build-cuda cmake-build-rocm cmake-build-metal cmake-clean
