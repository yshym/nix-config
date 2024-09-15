{ inputs, lib, pkgs, ... }:

{
  hardware = {
    asahi = {
      peripheralFirmwareDirectory = builtins.fetchTarball {
        url = "https://65c4a77cf00c00033cf84d2b--eclectic-horse-092596.netlify.app/firmware.tar.gz";
        sha256 = "01swixbj1vyksm8h1m2ppnyxdfl9p7gqaxgagql29bysvngr8win";
      };
      addEdgeKernelConfig = true;
      useExperimentalGPUDriver = true;
      # TODO Manage this purely
      # experimentalGPUInstallMode = "driver";
      experimentalGPUInstallMode = "replace";
      withRust = true;
    };
    opengl = {
      enable = true;
      driSupport = true;
    };
  };
}
