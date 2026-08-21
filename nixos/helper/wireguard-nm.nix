{ lib, ... }:
let
  mkAddresses =
    addrs:
    builtins.listToAttrs (
      lib.imap0 (i: addr: {
        name = "address${toString (i + 1)}";
        value = addr;
      }) addrs
    );

  mkDns = servers: builtins.concatStringsSep ";" servers + ";";

  mkPeer =
    {
      publicKey,
      endpoint ? null,
      allowedIPs ? [ ],
      preSharedKey ? null,
      keepAlive ? null,
    }:
    {
      "wireguard-peer.${publicKey}" = lib.filterAttrs (_: v: v != null) {
        inherit endpoint;
        allowed-ips = if allowedIPs != [ ] then builtins.concatStringsSep ";" allowedIPs + ";" else null;
        preshared-key = preSharedKey;
        preshared-key-flags = if preSharedKey != null then 0 else null;
        persistent-keepalive = keepAlive;
      };
    };

  mkPeers = peers: lib.mergeAttrsList (map mkPeer peers);

in
{
  mkWgProfile =
    {
      name,
      ifname,
      autoconnect ? false,
      privateKey,
      peers ? [ ],
      ipv4Addrs ? null,
      ipv4Dns ? null,
      ipv6Addrs ? null,
      ipv6Dns ? null,
    }:
    {
      connection = {
        id = name;
        type = "wireguard";
        interface-name = ifname;
        inherit autoconnect;
      };

      wireguard = {
        private-key = privateKey;
      };

      ipv4 =
        (lib.filterAttrs (_: v: v != null) {
          dns = if ipv4Dns != null then mkDns ipv4Dns else null;
          dns-search = if ipv4Dns != null then "~" else null;
        })
        // (if ipv4Addrs != null then mkAddresses ipv4Addrs else { })
        // {
          method = "manual";
        };

      ipv6 =
        (lib.filterAttrs (_: v: v != null) {
          dns = if ipv6Dns != null then mkDns ipv6Dns else null;
          dns-search = if ipv6Dns != null then "~" else null;
        })
        // (if ipv6Addrs != null then mkAddresses ipv6Addrs else { })
        // {
          method = "manual";
        };
    }
    // mkPeers peers;

  mkPeerWithCommonEp =
    {
      publicKey,
      endpoint ? null,
    }:
    {
      allowedIPs ? [ ],
      preSharedKey ? null,
      keepAlive ? null,
    }:
    {
      inherit
        publicKey
        endpoint
        allowedIPs
        preSharedKey
        keepAlive
        ;
    };

}
