all: build switch

build:
	jsonnet home-manager/programs/mcp/config.jsonnet > home-manager/programs/mcp/config.json

switch:
	nix run github:LnL7/nix-darwin -- switch --flake ".#shuntaka"

clean:
	rm -f home-manager/programs/mcp/config.json

.PHONY: all build switch clean