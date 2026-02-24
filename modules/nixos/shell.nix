{ pkgs, ... }: {
  # Shell configuration
  environment.localBinInPath = true;

  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" "sudo" "docker" "z" ];
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  users.defaultUserShell = pkgs.zsh;

  environment.shellAliases = {
    ll = "ls -l";
    la = "ls -la";
    rebuild = "sudo nixos-rebuild switch --flake .#phuctruong-nixos";
    update = "nix flake update";
  };
}
