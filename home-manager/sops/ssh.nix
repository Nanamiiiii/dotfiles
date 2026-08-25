{
  sops.secrets = {
    ssh-hosts-lab = {
      format = "binary";
      sopsFile = ../secrets/ssh-lab.conf.sops;
    };
    ssh-hosts-apal = {
      format = "binary";
      sopsFile = ../secrets/ssh-apal.conf.sops;
    };
  };
}
