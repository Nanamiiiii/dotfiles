{ pkgs, config, ... }:
{
  programs.hyprlock = {
    enable = true;
    settings = {
      background = {
        monitor = "";
        path = "${config.home.homeDirectory}/.wallpaper.jpg";
        blur_passes = 2;
        contrast = 0.8916;
        brightness = 0.8172;
        vibrancy = 0.1696;
        vibrancy_darkness = 0.0;
      };

      general = {
        no_fade_in = false;
        grace = 0;
        disable_loading_bar = false;
        enable_fingerprint = true;
      };

      label = [
        {
          monitor = "";
          text = ''
            cmd[update:1000] echo "<span>$(date +"%H:%M")</span>"
          '';
          color = "rgba(216, 222, 233, 0.70)";
          font_size = 90;
          font_family = "IBM Plex Sans JP Bold";
          position = "0, 350";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = ''
            cmd[update:1000] echo -e "$(date +"%Y/%m/%d")"
          '';
          color = "rgba(216, 222, 233, 0.70)";
          font_size = 30;
          font_family = "IBM Plex Sans JP";
          position = "0, 190";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = " $USER";
          color = "rgba(216, 222, 233, 0.80)";
          outline_thickness = 2;
          dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
          dots_spacing = 0.2; # Scale of dots' absolute size, 0.0 - 1.0
          dots_center = true;
          font_size = 16;
          font_family = "PlemolJP Console NF";
          position = "0, -130";
          halign = "center";
          valign = "center";
        }
      ];

      image = {
        monitor = "";
        path = "${config.home.homeDirectory}/.face.icon";
        border_size = 2;
        border_color = "rgba(255, 255, 255, .65)";
        size = 130;
        rounding = -1;
        rotate = 0;
        reload_time = -1;
        reload_cmd = "";
        position = "0, 40";
        halign = "center";
        valign = "center";
      };

      shape = {
        monitor = "";
        size = "300, 40";
        color = "rgba(255, 255, 255, .1)";
        rounding = -1;
        border_size = 0;
        border_color = "rgba(255, 255, 255, 0)";
        rotate = 0;
        xray = false; # if true, make a "hole" in the background (rectangle of specified size, no rotation)
        position = "0, -130";
        halign = "center";
        valign = "center";
      };

      input-field = {
        monitor = "";
        size = "300, 40";
        outline_thickness = 2;
        dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
        dots_spacing = 0.2; # Scale of dots' absolute size, 0.0 - 1.0
        dots_center = true;
        outer_color = "rgba(255, 255, 255, 0)";
        inner_color = "rgba(255, 255, 255, 0.1)";
        font_color = "rgb(200, 200, 200)";
        fade_on_empty = false;
        font_family = "PlemolJP Console NF";
        placeholder_text = "<span foreground='##ffffff99'>Enter password</span>";
        hide_input = false;
        position = "0, -210";
        halign = "center";
        valign = "center";
      };
    };
  };
}
