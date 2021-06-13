{ config, lib, pkgs, ... }:

{
  home-manager.users.yevhenshymotiuk = { pkgs, ... }: {
    home.packages = with pkgs; [ elixir erlang ];

    services = {
      spotifyd = {
        enable = true;
        settings = {
          global = {
            username = "31ar6mmjcalpg3e76aifbrzs55bi";
            password_cmd = "pass Spotify/31ar6mmjcalpg3e76aifbrzs55bi";
            use_keyring = true;
            backend = "pulseaudio";
            mixer = "PCM";
            volume_controller = "softvol";
            bitrate = 320;
            device_name = "rpi4";
            device_type = "speaker";
            initial_volume = "50";
            volume_normalization = false;
          };
        };
      };
    };
  };
}
