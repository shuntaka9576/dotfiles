all: fmt switch mcp

init: switch

update:
	nix flake update
	nix run github:berberman/nvfetcher -- -c "$(HOME)/dotfiles/nvfetcher.toml" -o "_sources"
	$(MAKE)

switch:
	sudo nix run github:LnL7/nix-darwin --extra-experimental-features 'flakes nix-command' -- switch --flake "path:.#shuntaka"

mcp: clean-mcp
	jsonnet --ext-str HOME="$$HOME" home-manager/programs/agent/mcp/mcp-general.jsonnet > home-manager/programs/agent/mcp/.mcp-general.json
	jsonnet --ext-str HOME="$$HOME" home-manager/programs/agent/mcp/mcp-code.jsonnet > home-manager/programs/agent/mcp/.mcp-code.json
	bun run home-manager/programs/agent/mcp/sync-mcp.ts

clean-mcp:
	rm -f home-manager/programs/agent/mcp/.mcp-general.json
	rm -f home-manager/programs/agent/mcp/.mcp-code.json

gc:
	nix-collect-garbage -d

fmt:
	nix fmt

STAMPS_DIR := .stamps
MISE_TOML := home-manager/programs/mise/mise.toml
DEFAULT_PYTHON_PKGS := home-manager/programs/mise/.default-python-packages
DEFAULT_GO_PKGS := home-manager/programs/mise/.default-go-packages
CLAUDE_VERSION := home-manager/programs/claude/.claude-version

tools: $(STAMPS_DIR)/tools-install $(STAMPS_DIR)/tools-default-packages $(STAMPS_DIR)/tools-claude

$(STAMPS_DIR)/tools-install: $(MISE_TOML)
	mise install
	@mkdir -p $(STAMPS_DIR)
	@touch $@

$(STAMPS_DIR)/tools-default-packages: $(DEFAULT_PYTHON_PKGS) $(DEFAULT_GO_PKGS) $(STAMPS_DIR)/tools-install
	mise install python --force
	mise install go --force
	@mkdir -p $(STAMPS_DIR)
	@touch $(STAMPS_DIR)/tools-install $@

$(STAMPS_DIR)/tools-claude: $(CLAUDE_VERSION)
	@bash home-manager/programs/claude/install.sh
	@mkdir -p $(STAMPS_DIR)
	@touch $@

tools-install:
	mise install
	@mkdir -p $(STAMPS_DIR)
	@touch $(STAMPS_DIR)/tools-install

tools-upgrade:
	mise upgrade

tools-default-packages:
	mise install python --force
	mise install go --force
	@mkdir -p $(STAMPS_DIR)
	@touch $(STAMPS_DIR)/tools-install $(STAMPS_DIR)/tools-default-packages

tools-claude:
	@bash home-manager/programs/claude/install.sh
	@mkdir -p $(STAMPS_DIR)
	@touch $(STAMPS_DIR)/tools-claude

clean-stamps:
	rm -rf $(STAMPS_DIR)

.PHONY: all init update switch mcp clean-mcp gc fmt tools tools-install tools-upgrade tools-default-packages tools-claude clean-stamps
