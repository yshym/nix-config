{ config, lib, pkgs, ... }:

{
  accounts.email.accounts = {
    gmail = {
      address = "yevhenshymotiuk@gmail.com";
      imap = {
        host = "imap.gmail.com";
        port = 993;
        tls = {
          enable = true;
          certificationFile = "/etc/ssl/certs/ca-certificates.crt";
        };
      };
      mbsync = {
        enable = true;
        create = "gmail";
      };
      primary = false;
      realName = "Yevhen Shymotiuk";
      passwordCommand = "pass google.com/yevhenshymotiuk@gmail.com/mail-fl";
      smtp.host = "smtp.gmail.com";
      userName = "yevhenshymotiuk@gmail.com";
    };
    protonmail = {
      address = "yevhenshymotiuk@pm.me";
      imap = {
        host = "127.0.0.1";
        port = 1143;
        tls = {
          enable = true;
          useStartTls = true;
          certificationFile =
            "${config.home.homeDirectory}/.config/protonmail/bridge/cert.pem";
        };
      };
      mbsync = {
        enable = true;
        create = "protonmail";
      };
      primary = true;
      realName = "Yevhen Shymotiuk";
      passwordCommand = "pass Proton/Mail/Bridge/yevhenshymotiuk";
      smtp = {
        host = "127.0.0.1";
        port = 1025;
      };
      userName = "yevhenshymotiuk@protonmail.com";
    };
  };
}
