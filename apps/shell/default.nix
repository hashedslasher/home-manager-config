
{
  config,
  pkgs,
  pkgs-unstable,
  lib,
  nixpkgs,
  ...
}:

let
  shellAliases = {
    tree = "tree -l";
    rg = "rg -L";
    l = "eza -la";
    ll = "eza -l";
  };

  shellEnabled = config.apps.shell.zsh.enable || config.apps.shell.bash.enable;

  commonRc = pkgs.writeScript "common-rc" ''
    export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --exclude .git --exclude .cache'
    
    f() {
      local out key file
      out=$(fzf --query="$1" --exit-0 --expect=ctrl-o,ctrl-e --preview="bat --color=always {}")
      
      if [ -n "$out" ]; then
        key=$(head -1 <<< "$out")
        file=$(head -2 <<< "$out" | tail -1)
        
        if [ -n "$file" ]; then
          if [ "$key" = "ctrl-o" ]; then
            xdg-open "$file"
          elif [ "$key" = "ctrl-e" ]; then
            ''$EDITOR "$file"
          else
            realpath "$file"
          fi
        fi
      fi
    }
  '';

in
{
  imports = [ ./starship ];
  
  options.apps.shell = {
    bash.enable = lib.mkEnableOption "bash config";
    zsh.enable = lib.mkEnableOption "zsh config";
  };

  config = lib.mkMerge [

    (lib.mkIf shellEnabled {
      programs.starship.enable = true;
      
      programs.fzf = {
        enable = true;
        enableZshIntegration = true;
        enableBashIntegration = true;
      };
      
      home.packages = with pkgs; [ 
        eza 
        bat 
      ];
    })

    (lib.mkIf config.apps.shell.zsh.enable {
      programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        initContent = "
          source ${commonRc}
        ";
        history.path = "${config.xdg.dataHome}/zsh/zsh_history";
        inherit shellAliases;
      };

      home.persistence = {
        link = {
          dir = [
            ".local/share/zsh"
          ];
        };
      };
    })

    (lib.mkIf config.apps.shell.bash.enable {
      programs.bash = {
        enable = true;
        initExtra = "
          source ${commonRc}
        ";
        inherit shellAliases;
      };
    })

  ];
}
