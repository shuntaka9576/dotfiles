all: fmt mcp switch

init: switch

update:
	nix flake update
	nix run github:berberman/nvfetcher -- -c "$(HOME)/dotfiles/nvfetcher.toml" -o "_sources"
	$(MAKE)

switch:
	sudo nix run github:LnL7/nix-darwin --extra-experimental-features 'flakes nix-command' -- switch --flake ".#shuntaka"

mcp: clean-mcp
	jsonnet home-manager/programs/mcp/mcp-general.jsonnet > home-manager/programs/mcp/.mcp-general.json
	jsonnet home-manager/programs/mcp/mcp-claude-code.jsonnet > home-manager/programs/mcp/.mcp-claude-code.json
	jq 'del(.mcpServers) + $$mcp[0]' ~/.config/claude/.claude.json --slurpfile mcp ~/dotfiles/home-manager/programs/mcp/.mcp-claude-code.json > ~/.config/claude/.claude.json.tmp && mv ~/.config/claude/.claude.json.tmp ~/.config/claude/.claude.json

clean-mcp:
	rm -f home-manager/programs/mcp/.mcp-general.json
	rm -f home-manager/programs/mcp/.mcp-claude-code.json

gc:
	nix-collect-garbage -d

fmt:
	nix fmt

.PHONY: all init update switch mcp clean-mcp gc fmt
