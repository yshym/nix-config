{ inputs, config, options, lib, pkgs, ... }:

with lib;
with lib.my;
{
  imports = [ ./cachix ] ++ (mapModulesRec' ./modules import);

  options = with types; {
    user = mkOpt attrs { name = ""; };
  };

  config = {
    assertions = [{
      assertion = config.user ? name;
      message = "config.user.name is not set!";
    }];

    user = {
      description = mkDefault "The primary user account";
      shell = pkgs.zsh;
    };
    users.users."${config.user.name}" = mkAliasDefinitions options.user;

    environment.systemPackages = with pkgs; [ bash coreutils gcc git ripgrep vim wget ];

    fonts.packages = with pkgs; [
      dejavu_fonts
      fira-code
      font-awesome
      jetbrains-mono
      (joypixels.override { acceptLicense = true; })
      noto-fonts
      noto-fonts-cjk-sans
    ];

    nix = {
      package = pkgs.nixVersions.nix_2_28;
      settings = {
        sandbox = true;
        trusted-users = [ "root" config.user.name ];
      };
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
      nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    };

    programs = {
      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };
    };

    modules = {
      dev = {
        python = {
          enable = true;
          extraPackages = with pkgs.python3Packages; [ python-lsp-server ];
          black = {
            enable = false;
            settings.line-length = 79;
          };
          mypy = {
            enable = true;
            settings.ignore_missing_imports = true;
          };
          pylint.enable = false;
        };
        ruby = {
          enable = false;
          enableBuildLibs = true;
          provider = "nixpkgs";
          enableSolargraph = true;
        };
        nodejs = {
          enable = true;
          yarn.enable = true;
        };
        prettier.enable = true;
      };
      editors.emacs.enable = true;
      shell = {
        git = {
          enable = true;
          pager = "diff-so-fancy";
        };
        man.enable = true;
      };
    };

    time.timeZone = "Europe/Kiev";
  };
}
