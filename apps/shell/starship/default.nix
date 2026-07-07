{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.starship = {
    settings = {
      add_newline = false;
      scan_timeout = 10;
      format = lib.concatStrings [
        "$os"
        "$hostname"
        "$nix_shell"
        "$directory"
        "$git_branch"
        "$git_status"
        "$fill"
        "$status"
        "$shell"
        "$time"
        "$line_break"
        "$character"
      ];

      os = {
        disabled = false;
        format = "[$symbol](bold white) ";
        symbols = lib.importTOML ./os_symbols.toml;
      };

      nix_shell = {
        disabled = false;
        format = "[$name](white) $state ";
        impure_msg = "[impure](bold dimmed red)";
        pure_msg = "[pure](bold dimmed green)";
        style = "bold italic dimmed blue";
        unknown_msg = "[]";
        heuristic = false;
      };

      directory = {
        format = "[$path]($style) [$read_only]($read_only_style) ";
        style = "bold fg:#a0a9cb";
        read_only = "";
        read_only_style = "white";
      };

      git_branch = {
        format = "[ $branch](fg:#9198a1)";
      };

      git_status = {
        ahead = "⇡$count";
        behind = "⇣$count";
        diverged = "⇕⇡$ahead_count⇣$behind_count";
        format = "[[( $all_status$ahead_behind )](fg:#769ff0)]($style)";
        style = "bg:#394260";
      };

      status = {
        disabled = false;
        format = "[$symbol]($style) ";
        symbol = " $status";
        success_symbol = "󰄬";
        style = "bold red";
        success_style = "bold green";
        recognize_signal_code = false;
      };

      shell = {
        style = "bold gray";
        disabled = false;
      };

      time = {
        disabled = false;
        format = "[[ $time ](fg:#a0a9cb)]($style)";
        time_format = "%T";
      };

      character = {
        format = "[[❯](fg:#a0a9cb)]($style) ";
      };

      fill = {
        symbol = " ";
      };
    };
  };
}
