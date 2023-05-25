function FindProxyForURL(url, host)
{
    if (shExpMatch(host, "ieeexplore.ieee.org"))      // IEEE Xplore
        return "SOCKS localhost:10023; DIRECT";
    else if (shExpMatch(host, "dl.acm.org"))          // ACM Digital Library
        return "SOCKS localhost:10023; DIRECT";
    else if (shExpMatch(host, "*.springer.com"))      // Springer Link
        return "SOCKS localhost:10023; DIRECT";
    else if (shExpMatch(host, "ipsj.ixsq.nii.ac.jp")) // 情報処理学会電子図書館
        return "SOCKS localhost:10023; DIRECT";
    else if (shExpMatch(host, "www.mendeley.com"))    // Mendeley
        return "SOCKS localhost:10023; DIRECT";
    else if (shExpMatch(host, "id.elsevier.com"))     // Mendeley Login
        return "SOCKS localhost:10023; DIRECT";
    else if (shExpMatch(host, "www.apal.cs.waseda.ac.jp"))     // Wiki
        return "SOCKS localhost:10023; DIRECT";
    else
        return "DIRECT";
}
