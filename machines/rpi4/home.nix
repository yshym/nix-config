{ config, lib, pkgs, ... }:

{
  home-manager.users.yevhenshymotiuk = { pkgs, ... }: {
    services = {
      spotifyd = {
        enable = true;
        settings = {
          global = {
            username = "31ar6mmjcalpg3e76aifbrzs55bi";
            password_cmd = "pass Spotify/31ar6mmjcalpg3e76aifbrzs55bi";
            use_keyring = true;
            backend = "alsa";
            device = "default";
            control = "default";
            mixer = "PCM";
            volume_controller = "softvol";
            bitrate = 320;
            device_name = "rpi4";
            device_type = "speaker";
            initial_volume = "70";
            volume_normalization = false;
          };
        };
      };
    };
  };
}
