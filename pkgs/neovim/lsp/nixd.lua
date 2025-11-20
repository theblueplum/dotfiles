return {
	cmd = { 'nixd' },
	filetypes = { 'nix' },
	root_markers = { { 'configuration.nix', 'flake.nix', 'default.nix' } },
	settings = {
		nixd = {
			options = {
				nixos = {
					expr = [[
						(import <nixpkgs/nixos/lib/eval-config.nix> {
							modules = [
								<nixos-config>
								/etc/nixos/hardware-configuration.nix
							];
						})
						.options
					]]
				},
				['home-manager'] = {
					expr = [[
						let 
							pkgs = import <nixpkgs> {};
							config = pkgs.callPackage <nixos-config> {};
							home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-${config.system.stateVersion}.tar.gz";
						in
							(import "${home-manager}/modules" {
								inherit pkgs;
								configuration = /etc/nixos/home.nix;
							})
							.options
					]]
				}
			}
		}
	}
}
