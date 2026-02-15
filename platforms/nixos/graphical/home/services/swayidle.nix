{ ... }:

{
  services.swayidle = {
    enable = true;
    timeouts = [{ timeout = 600; command = "swaylock-wrapper"; }];
    events = [{ event = "before-sleep"; command = "swaylock-wrapper"; }];
  };
}
