{ ... }:

{
  services.adguardhome = {
    enable = true;
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