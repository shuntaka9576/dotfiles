all: fmt mcp switch

init: switch

update:
	nix flake update
	nix run github:berberman/nvfetcher -- -c "$(HOME)/dotfiles/nvfetcher.toml" -o "_sources"
	$(MAKE)

switch:
	sudo nix run github:LnL7/nix-darwin --extra-experimental-features 'flakes nix-command' -- switch --flake "path:.#shuntaka"

mcp: clean-mcp
	jsonnet --ext-str HOME="$$HOME" home-manager/programs/mcp/mcp-general.jsonnet > home-manager/programs/mcp/.mcp-general.json
	jsonnet --ext-str HOME="$$HOME" home-manager/programs/mcp/mcp-claude-code.jsonnet > home-manager/programs/mcp/.mcp-claude-code.json
	jq 'del(.mcpServers) + $$mcp[0]' ~/.config/claude/.claude.json --slurpfile mcp ~/dotfiles/home-manager/programs/mcp/.mcp-claude-code.json > ~/.config/claude/.claude.json.tmp && mv ~/.config/claude/.claude.json.tmp ~/.config/claude/.claude.json

clean-mcp:
	rm -f home-manager/programs/mcp/.mcp-general.json
	rm -f home-manager/programs/mcp/.mcp-claude-code.json

gc:
	nix-collect-garbage -d

fmt:
	nix fmt

node:
	mise uninstall node --all
	mise install node

python:
	mise uninstall python --all
	mise install python

pnpm-global:
	@while IFS= read -r pkg || [ -n "$$pkg" ]; do \
		[ -z "$$pkg" ] && continue; \
		pnpm add -g "$$pkg"; \
	done < home-manager/programs/pnpm/global-packages

.PHONY: all init update switch mcp clean-mcp gc fmt node python pnpm-global
