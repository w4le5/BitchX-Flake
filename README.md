# BitchX Nix Flake

A Nix flake that builds [BitchX](https://github.com/BitchX/BitchX1.3), a classic terminal IRC client.

> Note: BitchX is licensed under GPLv2+

## Usage

### 1. Add an input and overlay to your `flake.nix`
> Replace `HOSTNAME` with your actual hostname
```nix
{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    bitchx.url = "github:w4le5/BitchX-Flake";
  };

  outputs = { self, nixpkgs, bitchx, ... }: {
    nixosConfigurations.HOSTNAME = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ({ pkgs, ... }: {
          nixpkgs.overlays = [ bitchx.overlay ];
        })
        ./configuration.nix
      ];
    };
  };
}
```
### 2. Add the package to your `configuration.nix` or `home.nix`
```nix
{ pkgs, ... }: {
  environment.systemPackages = [ pkgs.bitchx ]; # in configuration.nix
  home.packages = [ pkgs.bitchx ]; # in home.nix
}
```
