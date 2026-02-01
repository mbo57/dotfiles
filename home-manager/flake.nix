{
  description = "Home Manager configuration of mbo57";
  nixConfig = {
    allowUnfree = true;
  };

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11"; # stable
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # hyprsome.url = "github:sopa0/hyprsome";
  };

  outputs =
    { nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; config = { allowUnfree = true; }; };
      pkgs-unstable = import nixpkgs-unstable { inherit system; config = { allowUnfree = true; }; };
      # pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      homeConfigurations."mbo57" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home.nix ];

        extraSpecialArgs = { 
          inherit inputs;
          pkgs-unstable = pkgs-unstable;
        };
      };
    };
}
# {
#   inputs = {
#     nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05"; # stable
#     nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
#     home-manager.url = "github:nix-community/home-manager";
#     home-manager.inputs.nixpkgs.follows = "nixpkgs";
#   };
#
#   outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs:
#     let
#       system = "x86_64-linux";
#       pkgs = import nixpkgs { inherit system; };
#       unstable = import nixpkgs-unstable { inherit system; };
#     in {
#       nixosConfigurations = {
#         myhost = nixpkgs.lib.nixosSystem {
#           inherit system;
#           modules = [
#             ./configuration.nix
#             home-manager.nixosModules.home-manager
#             {
#               home-manager.useGlobalPkgs = true;
#               home-manager.useUserPackages = true;
#               home-manager.users.myuser = import ./home.nix;
#               home-manager.extraSpecialArgs = { inherit unstable; };
#             }
#           ];
#         };
#       };
#     };
# }
#
