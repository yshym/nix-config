{ config, lib, pkgs, ... }:

{
  services.spotifyd = {
    enable = true;
    settings.global = {
      backend = "alsa";
      device = "default";
      control = "default";
      bitrate = 320;
      device_name = "fl";
      device_type = "computer";
      initial_volume = "50";
      mixer = "PCM";
      password_cmd = "pass Spotify/31ar6mmjcalpg3e76aifbrzs55bi";
      use_keyring = false;
      username = "31ar6mmjcalpg3e76aifbrzs55bi";
      volume_controller = "softvol";
      volume_normalisation = false;
      normalisation_pregain = 1;
    };
  };
}
