{
  ipv4Addrs,
  ipv6Addrs,
}:
{ lib, config, ... }:
let
  wireguardNm = import ../../../../helper/wireguard-nm.nix { inherit lib; };

  mkPeerWghCli = wireguardNm.mkPeerWithCommonEp {
    publicKey = "RI1K175JhdMdG7Agf+gxs7iEIMjGLDYREOsUbbutjVI=";
    endpoint = "nazupi.myuu.dev:62211";
  };

in
{
  networking.networkmanager.ensureProfiles = {
    environmentFiles = [ config.sops.secrets.wgenv.path ];

    profiles = {
      wg-home = wireguardNm.mkWgProfile {
        name = "wg-home";
        ifname = "wgh";
        privateKey = "$WGH_PRIV";
        peers = [
          (mkPeerWghCli {
            allowedIPs = [
              "10.27.0.0/24"
              "10.27.1.0/24"
              "fd00::/64"
              "fd00:1::/64"
              "172.16.0.0/16"
              "172.27.0.0/16"
            ];
            preSharedKey = "$WGH_PSK";
            keepAlive = 25;
          })
        ];
        ipv4Dns = [ "10.27.1.1" ];
        inherit
          ipv4Addrs
          ipv6Addrs
          ;
      };

      wg-nazu = wireguardNm.mkWgProfile {
        name = "wg-nazu";
        ifname = "wgh";
        privateKey = "$WGH_PRIV";
        peers = [
          (mkPeerWghCli {
            allowedIPs = [
              "10.27.0.0/24"
              "10.27.1.0/24"
              "fd00::/64"
              "fd00:1::/64"
            ];
            preSharedKey = "$WGH_PSK";
            keepAlive = 25;
          })
        ];
        inherit
          ipv4Addrs
          ipv6Addrs
          ;
      };

      wg-nazu-tun = wireguardNm.mkWgProfile {
        name = "wg-nazu-tun";
        ifname = "wgh";
        privateKey = "$WGH_PRIV";
        peers = [
          (mkPeerWghCli {
            allowedIPs = [
              "0.0.0.0/0"
              "::/0"
            ];
            preSharedKey = "$WGH_PSK";
            keepAlive = 25;
          })
        ];
        ipv4Dns = [ "10.27.1.1" ];
        inherit
          ipv4Addrs
          ipv6Addrs
          ;
      };
    };
  };
}
