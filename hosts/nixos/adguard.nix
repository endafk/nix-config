{ ... }:

{
  services.adguardhome = {
  enable = true;
  host = "127.0.0.1"; # Opens TCP/UDP 53 and TCP 3000 for the UI
  port = 3000;
  };
  # Force the local system to query the local AdGuard daemon
  networking.nameservers = [ "127.0.0.1" ];

  # Castrate NetworkManager so DHCP leases don't overwrite your DNS settings
  networking.networkmanager.dns = "none";

  # Kill systemd-resolved
  services.resolved.enable = false;

  # Force standard resolv.conf generation pointing strictly to AdGuard
  environment.etc."resolv.conf".text = ''
    nameserver 127.0.0.1
    options edns0 trust-ad
  '';


  services.adguardhome = {
    settings = {
      dns = {
        upstream_dns = [
          "tls://dns.quad9.net"
          "quic://dns.adguard-dns.com"
          "https://security.cloudflare-dns.com/dns-query"
        ];
        bootstrap_dns = [
          "9.9.9.9"
          "1.1.1.1"
        ];
        # Consolidate your cache settings into the single DNS block
        cache_optimistic = true;
        cache_size = 4194304; 
      };

      filters = [
        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt";
          name = "AdGuard DNS filter";
        }
        {
          enabled = true;
          url = "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/proplus.txt";
          name = "HaGeZi Pro++";
        }
      ];
    };
  };
}