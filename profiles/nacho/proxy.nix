{
  networking.proxy = {
    default = "http://marine-internal.kasahara.cs.waseda.ac.jp:3128";
    allProxy = "http://marine-internal.kasahara.cs.waseda.ac.jp:3128";
    noProxy = "127.0.0.1,localhost,.kasahara.cs.waseda.ac.jp,133.9.80.0/26,133.9.80.128/26,192.168.50.0/23";
  };
}
