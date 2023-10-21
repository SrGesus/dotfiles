{
  description = "My Home Manager";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  
  outputs = { nixpkgs, home-manager, ... }: {
    defaultPackage.x86_64-linux = home-manager.defaultPackage.x86_64-linux;

    homeConfigurations = {
            
            "user" = home-manager.lib.homeManagerConfiguration {
                pkgs = import nixpkgs { 
                  system = "x86_64-linux"; 
                  config = { allowUnfree = true; };
                };

                modules = [ ./home.nix ];
            };
        };
  };
}
