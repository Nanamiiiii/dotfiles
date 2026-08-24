{
  ipv4Addrs,
  ipv6Addrs,
}:
{ lib, config, ... }:
let
  wireguardNm = import ../../../../helper/wireguard-nm.nix { inherit lib; };

  mkPeerWglCli = wireguardNm.mkPeerWithCommonEp {
    publicKey = "OL5EnNaOW3Lni8/WVEfUdkWPMBEtSZx26oWudJ87skM=";
    endpoint = "nazupi.myuu.dev:62213";
  };
in
{
  networking.networkmanager.ensureProfiles = {
    environmentFiles = [ config.sops.secrets.wgenv.path ];

    profiles = {
      wg-lab = wireguardNm.mkWgProfile {
        name = "wg-lab";
        ifname = "wgl";
        privateKey = "$WGL_PRIV";
        peers = [
          (mkPeerWglCli {
            allowedIPs = [
              "10.27.2.0/24"
              "10.27.3.0/24"
              "fd00:2::/64"
              "fd00:3::/64"
              "133.9.80.0/26"
              "133.9.80.128/26"
              "192.168.50.0/23"
              "133.9.86.235/32"
            ];
            preSharedKey = "$WGL_PSK";
            keepAlive = 25;
          })
        ];
        inherit
          ipv4Addrs
          ipv6Addrs
          ;
      };

      wg-lab-tun = wireguardNm.mkWgProfile {
        name = "wg-lab-tun";
        ifname = "wgl";
        privateKey = "$WGL_PRIV";
        peers = [
          (mkPeerWglCli {
            allowedIPs = [
              "0.0.0.0/0"
              "::/0"
            ];
            preSharedKey = "$WGL_PSK";
            keepAlive = 25;
          })
        ];
        ipv4Dns = [ "133.9.80.2" ];
        inherit
          ipv4Addrs
          ipv6Addrs
          ;
      };
    };
  };
}
