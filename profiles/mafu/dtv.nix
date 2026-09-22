{ pkgs, config, ... }:
{
  # automount
  services.autofs = {
    enable = true;
    autoMaster =
      let
        mapConf = pkgs.writeText "auto" ''
          dvr -fstype=nfs4,rw 172.27.10.1:/mnt/main/dvr
        '';
      in
      ''
        /mnt/auto file:${mapConf}
      '';
  };

  # enable dtv stack
  services.dtv = {
    enable = true;

    # recording dir
    recordingDir = [
      "/mnt/auto/dvr/recordings"
      "/mnt/auto/dvr/anime"
      "/mnt/auto/dvr/drama"
      "/mnt/auto/dvr/sports"
      "/mnt/auto/dvr/info"
      "/mnt/auto/dvr/misc"
    ];

    # firewall settings
    openFirewall = true;

    # services
    px4_drv.enable = true;
    mirakurun.enable = true;
    edcb.enable = true;
    konomitv.enable = true;
  };

  # mirakurun settings
  services.mirakurun = {
    serverSettings = {
      logLevel = 1;
      hostname = "mafu.myuu.internal";
    };

    # e-Better DTV02A-4TS-P with recisdb
    tunerSettings = [
      {
        name = "DTV02A-4TS-P #1";
        types = [
          "GR"
          "BS"
          "CS"
        ];
        command = "recisdb tune --device /dev/isdb6014video0 --channel <channel><satellite>-";
      }
      {
        name = "DTV02A-4TS-P #2";
        types = [
          "GR"
          "BS"
          "CS"
        ];
        command = "recisdb tune --device /dev/isdb6014video1 --channel <channel><satellite>-";
      }
      {
        name = "DTV02A-4TS-P #3";
        types = [
          "GR"
          "BS"
          "CS"
        ];
        command = "recisdb tune --device /dev/isdb6014video2 --channel <channel><satellite>-";
      }
      {
        name = "DTV02A-4TS-P #4";
        types = [
          "GR"
          "BS"
          "CS"
        ];
        command = "recisdb tune --device /dev/isdb6014video3 --channel <channel><satellite>-";
      }
    ];
  };

  # EDCB settings
  services.edcb = {
    settings = {
      SET = {
        # recording name rule
        RecNamePlugIn = 1;
        RecNamePlugInFile = "RecName_Macro.so";
      };

      # EPG fetch schedule
      EPG_CAP = {
        Count = 3;
        "0" = "05:15";
        "0Select" = 1;
        "0BasicOnlyFlags" = 14;
        "1" = "11:15";
        "1Select" = 1;
        "1BasicOnlyFlags" = 14;
        "2" = "17:15";
        "2Select" = 1;
        "2BasicOnlyFlags" = 14;
      };
    };

    recNameMacroSettings = {
      SET.Macro = "$ZtoH(Title)$.ts";
    };

    bondriver = [
      {
        # BonDriver for mirakurun
        name = "BonDriver_LinuxMirakc.so";
        driverPath = "${pkgs.bondriver-linux-mirakc}/lib/BonDriver_LinuxMirakc.so";
        settings = {
          GLOBAL = {
            SERVER_HOST = "127.0.0.1";
            SERVER_PORT = config.services.mirakurun.port;
            DECODE_B25 = 0; # decoded in mirakurun
            PRIORITY = 100;
            SERVICE_SPLIT = 0;
          };
        };
        tunerSettings = {
          Count = 4;
          GetEpg = 1;
          EPGCount = 2;
        };
      }
    ];

    # for nfs mount
    manageRecordingDirs = false;

    # enable EDCB Material Web UI 3
    materialWebUI = {
      enable = true;
      extraCertificateSubjectAltNames = [
        "DNS:mafu.myuu.internal"
        "IP:172.27.10.3"
      ];
    };
  };

  # konomitv settings
  services.konomitv = {
    # enable intel qsv
    encoder = "QSVEncC";

    # screen capture directory
    captureDir = [ "/mnt/auto/dvr/capture" ];

    # for nfs mount
    manageCaptureDirs = false;
  };
}
