{ ... }:

{
  programs.swaylock.enable = true;

  services.swayidle = {
    enable = true;
    timeouts = [{ timeout = 600; command = "swaylock-wrapped"; }];
    events = [{ event = "before-sleep"; command = "swaylock-wrapped"; }];
  };
}
