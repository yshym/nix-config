{ config, lib, pkgs, ... }:

{
  accounts.email = {
    maildirBasePath = ".mail";
    accounts = {
      gmail = {
        primary = false;
        address = "yevhenshymotiuk@gmail.com";
        userName = "yevhenshymotiuk@gmail.com";
        realName = "Yevhen Shymotiuk";
        passwordCommand = "pass google.com/yevhenshymotiuk@gmail.com/mail-fl";
        imap = {
          host = "imap.gmail.com";
          port = 993;
          tls = {
            enable = true;
            certificatesFile = "/etc/ssl/certs/ca-certificates.crt";
          };
        };
        smtp.host = "smtp.gmail.com";
        imapnotify = {
          enable = true;
          boxes = [
            "INBOX"
            "[Gmail]/Sent Mail"
            "[Gmail]/All Mail"
            "[Gmail]/Starred"
          ];
          onNotify = "${pkgs.isync}/bin/mbsync --pull --new gmail";
          onNotifyPost =
            "'if ${pkgs.mu}/bin/mu index --lazy-check; then test -f /tmp/mu_reindex_now && rm /tmp/mu_reindex_now; else touch /tmp/mu_reindex_now; fi'";
        };
        mbsync = {
          enable = true;
          create = "both";
          expunge = "both";
          groups.gmail.channels = {
            inbox = {
              farPattern = "INBOX";
              nearPattern = "inbox";
              extraConfig = {
                Create = "both";
                Expunge = "both";
                SyncState = "*";
              };
            };
            sent = {
              farPattern = "[Gmail]/Sent Mail";
              nearPattern = "sent";
              extraConfig = {
                Create = "both";
                Expunge = "both";
                SyncState = "*";
              };
            };
            all = {
              farPattern = "[Gmail]/All Mail";
              nearPattern = "all";
              extraConfig = {
                Create = "both";
                Expunge = "both";
                SyncState = "*";
              };
            };
            starred = {
              farPattern = "[Gmail]/Starred";
              nearPattern = "starred";
              extraConfig = {
                Create = "both";
                Expunge = "both";
                SyncState = "*";
              };
            };
          };
        };
      };
      protonmail = {
        primary = true;
        address = "yshym@pm.me";
        realName = "Yevhen Shymotiuk";
        userName = "yshym@pm.me";
        passwordCommand = "pass protonmail.com/bridge/yshym";
        imap = {
          host = "127.0.0.1";
          port = 1143;
          tls = {
            enable = false;
            useStartTls = true;
            certificatesFile =
              "${config.home.homeDirectory}/.config/protonmail/bridge/cert.pem";
          };
        };
        smtp = {
          host = "127.0.0.1";
          port = 1025;
        };
        imapnotify = {
          enable = true;
          boxes = [ "INBOX" "Sent" "All Mail" ];
          onNotify = "${pkgs.isync}/bin/mbsync --pull --new protonmail";
          onNotifyPost =
            "'if ${pkgs.mu}/bin/mu index --lazy-check; then test -f /tmp/mu_reindex_now && rm /tmp/mu_reindex_now; else touch /tmp/mu_reindex_now; fi'";
        };
        mbsync = {
          enable = true;
          create = "both";
          expunge = "both";
          groups.protonmail.channels = {
            inbox = {
              farPattern = "INBOX";
              nearPattern = "inbox";
              extraConfig = {
                Create = "both";
                Expunge = "both";
                SyncState = "*";
              };
            };
            sent = {
              farPattern = "Sent";
              nearPattern = "sent";
              extraConfig = {
                Create = "both";
                Expunge = "both";
                SyncState = "*";
              };
            };
            all = {
              farPattern = "All Mail";
              nearPattern = "all";
              extraConfig = {
                Create = "both";
                Expunge = "both";
                SyncState = "*";
              };
            };
          };
        };
      };
    };
  };
}
