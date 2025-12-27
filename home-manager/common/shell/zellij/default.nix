{
  programs.zellij = {
    enable = true;
    enableZshIntegration = false;
    settings = {
      theme = "iceberg-dark";
      default_mode = "locked";
      default_layout = "compact";
      pane_frames = false;
      mouse_mode = false;
      show_startup_tips = false;
      plugins = {
        about._props.location = "zellij:about";
        compact-bar._props.location = "zellij:compact-bar";
        configuration._props.location = "zellij:configuration";
        filepicker = {
          _props.location = "zellij:strider";
          _children = [
            { cwd = "/"; }
          ];
        };
        plugin-manager._props.location = "zellij:plugin-manager";
        session-manager._props.location = "zellij:session-manager";
        status-bar._props.location = "zellij:status-bar";
        strider._props.location = "zellij:strider";
        tab-bar._props.location = "zellij:tab-bar";
        welcome-screen = {
          _props.location = "zellij:session-manager";
          _children = [
            { welcome_screen = true; }
          ];
        };
      };
    };
    extraConfig = ''
      keybinds clear-defaults=true {
          locked {
              bind "Ctrl g" { SwitchToMode "normal"; }
          }
          pane {
              bind "left" { MoveFocus "left"; }
              bind "down" { MoveFocus "down"; }
              bind "up" { MoveFocus "up"; }
              bind "right" { MoveFocus "right"; }
              bind "c" { SwitchToMode "renamepane"; PaneNameInput 0; }
              bind "d" { NewPane "down"; SwitchToMode "locked"; }
              bind "e" { TogglePaneEmbedOrFloating; SwitchToMode "locked"; }
              bind "f" { ToggleFocusFullscreen; SwitchToMode "locked"; }
              bind "h" { MoveFocus "left"; }
              bind "i" { TogglePanePinned; SwitchToMode "locked"; }
              bind "j" { MoveFocus "down"; }
              bind "k" { MoveFocus "up"; }
              bind "l" { MoveFocus "right"; }
              bind "n" { NewPane; SwitchToMode "locked"; }
              bind "p" { SwitchFocus; }
              bind "Ctrl p" { SwitchToMode "locked"; }
              bind "r" { NewPane "right"; SwitchToMode "locked"; }
              bind "s" { NewPane "stacked"; SwitchToMode "locked"; }
              bind "w" { ToggleFloatingPanes; SwitchToMode "locked"; }
              bind "z" { TogglePaneFrames; SwitchToMode "locked"; }
          }
          tab {
              bind "left" { GoToPreviousTab; }
              bind "down" { GoToNextTab; }
              bind "up" { GoToPreviousTab; }
              bind "right" { GoToNextTab; }
              bind "1" { GoToTab 1; SwitchToMode "locked"; }
              bind "2" { GoToTab 2; SwitchToMode "locked"; }
              bind "3" { GoToTab 3; SwitchToMode "locked"; }
              bind "4" { GoToTab 4; SwitchToMode "locked"; }
              bind "5" { GoToTab 5; SwitchToMode "locked"; }
              bind "6" { GoToTab 6; SwitchToMode "locked"; }
              bind "7" { GoToTab 7; SwitchToMode "locked"; }
              bind "8" { GoToTab 8; SwitchToMode "locked"; }
              bind "9" { GoToTab 9; SwitchToMode "locked"; }
              bind "[" { BreakPaneLeft; SwitchToMode "locked"; }
              bind "]" { BreakPaneRight; SwitchToMode "locked"; }
              bind "b" { BreakPane; SwitchToMode "locked"; }
              bind "h" { GoToPreviousTab; }
              bind "j" { GoToNextTab; }
              bind "k" { GoToPreviousTab; }
              bind "l" { GoToNextTab; }
              bind "n" { NewTab; SwitchToMode "locked"; }
              bind "r" { SwitchToMode "renametab"; TabNameInput 0; }
              bind "s" { ToggleActiveSyncTab; SwitchToMode "locked"; }
              bind "Ctrl t" { SwitchToMode "locked"; }
              bind "x" { CloseTab; SwitchToMode "locked"; }
              bind "tab" { ToggleTab; }
          }
          resize {
              bind "left" { Resize "Increase left"; }
              bind "down" { Resize "Increase down"; }
              bind "up" { Resize "Increase up"; }
              bind "right" { Resize "Increase right"; }
              bind "+" { Resize "Increase"; }
              bind "-" { Resize "Decrease"; }
              bind "=" { Resize "Increase"; }
              bind "H" { Resize "Decrease left"; }
              bind "J" { Resize "Decrease down"; }
              bind "K" { Resize "Decrease up"; }
              bind "L" { Resize "Decrease right"; }
              bind "h" { Resize "Increase left"; }
              bind "j" { Resize "Increase down"; }
              bind "k" { Resize "Increase up"; }
              bind "l" { Resize "Increase right"; }
              bind "Ctrl n" { SwitchToMode "locked"; }
          }
          move {
              bind "left" { MovePane "left"; }
              bind "down" { MovePane "down"; }
              bind "up" { MovePane "up"; }
              bind "right" { MovePane "right"; }
              bind "h" { MovePane "left"; }
              bind "Ctrl h" { SwitchToMode "locked"; }
              bind "j" { MovePane "down"; }
              bind "k" { MovePane "up"; }
              bind "l" { MovePane "right"; }
              bind "n" { MovePane; }
              bind "p" { MovePaneBackwards; }
              bind "tab" { MovePane; }
          }
          scroll {
              bind "e" { EditScrollback; SwitchToMode "locked"; }
              bind "s" { SwitchToMode "entersearch"; SearchInput 0; }
          }
          search {
              bind "c" { SearchToggleOption "CaseSensitivity"; }
              bind "n" { Search "down"; }
              bind "o" { SearchToggleOption "WholeWord"; }
              bind "p" { Search "up"; }
              bind "w" { SearchToggleOption "Wrap"; }
          }
          session {
              bind "a" {
                  LaunchOrFocusPlugin "zellij:about" {
                      floating true
                      move_to_focused_tab true
                  }
                  SwitchToMode "locked"
              }
              bind "c" {
                  LaunchOrFocusPlugin "configuration" {
                      floating true
                      move_to_focused_tab true
                  }
                  SwitchToMode "locked"
              }
              bind "Ctrl o" { SwitchToMode "locked"; }
              bind "p" {
                  LaunchOrFocusPlugin "plugin-manager" {
                      floating true
                      move_to_focused_tab true
                  }
                  SwitchToMode "locked"
              }
              bind "s" {
                  LaunchOrFocusPlugin "zellij:share" {
                      floating true
                      move_to_focused_tab true
                  }
                  SwitchToMode "locked"
              }
              bind "w" {
                  LaunchOrFocusPlugin "session-manager" {
                      floating true
                      move_to_focused_tab true
                  }
                  SwitchToMode "locked"
              }
          }
          shared_except "locked" {
              bind "Ctrl Alt left" { MoveFocusOrTab "left"; }
              bind "Ctrl Alt down" { MoveFocus "down"; }
              bind "Ctrl Alt up" { MoveFocus "up"; }
              bind "Ctrl Alt right" { MoveFocusOrTab "right"; }
              bind "Ctrl Alt +" { Resize "Increase"; }
              bind "Ctrl Alt -" { Resize "Decrease"; }
              bind "Ctrl Alt =" { Resize "Increase"; }
              bind "Ctrl Alt [" { PreviousSwapLayout; }
              bind "Ctrl Alt ]" { NextSwapLayout; }
              bind "Ctrl Alt f" { ToggleFloatingPanes; }
              bind "Ctrl g" { SwitchToMode "locked"; }
              bind "Ctrl Alt h" { MoveFocusOrTab "left"; }
              bind "Ctrl Alt i" { MoveTab "left"; }
              bind "Ctrl Alt j" { MoveFocus "down"; }
              bind "Ctrl Alt k" { MoveFocus "up"; }
              bind "Ctrl Alt l" { MoveFocusOrTab "right"; }
              bind "Ctrl Alt n" { NewPane; }
              bind "Ctrl Alt o" { MoveTab "right"; }
              bind "Ctrl Alt p" { TogglePaneInGroup; }
              bind "Ctrl Shift p" { ToggleGroupMarking; }
              bind "Ctrl q" { Quit; }
          }
          shared_except "locked" "move" {
              bind "Ctrl h" { SwitchToMode "move"; }
          }
          shared_except "locked" "session" {
              bind "Ctrl o" { SwitchToMode "session"; }
          }
          shared_except "scroll" "search" "tmux" {
              bind "Ctrl b" { SwitchToMode "tmux"; }
          }
          shared_except "locked" "scroll" "search" {
              bind "Ctrl s" { SwitchToMode "scroll"; }
          }
          shared_except "locked" "tab" {
              bind "Ctrl t" { SwitchToMode "tab"; }
          }
          shared_except "locked" "pane" {
              bind "Ctrl p" { SwitchToMode "pane"; }
          }
          shared_except "locked" "resize" {
              bind "Ctrl n" { SwitchToMode "resize"; }
          }
          shared_except "locked" "entersearch" {
              bind "enter" { SwitchToMode "locked"; }
          }
          shared_except "locked" "entersearch" "renametab" "renamepane" {
              bind "esc" { SwitchToMode "locked"; }
          }
          shared_among "pane" "tmux" {
              bind "x" { CloseFocus; SwitchToMode "locked"; }
          }
          shared_among "scroll" "search" {
              bind "PageDown" { PageScrollDown; }
              bind "PageUp" { PageScrollUp; }
              bind "left" { PageScrollUp; }
              bind "down" { ScrollDown; }
              bind "up" { ScrollUp; }
              bind "right" { PageScrollDown; }
              bind "Ctrl b" { PageScrollUp; }
              bind "Ctrl c" { ScrollToBottom; SwitchToMode "locked"; }
              bind "d" { HalfPageScrollDown; }
              bind "Ctrl f" { PageScrollDown; }
              bind "h" { PageScrollUp; }
              bind "j" { ScrollDown; }
              bind "k" { ScrollUp; }
              bind "l" { PageScrollDown; }
              bind "Ctrl s" { SwitchToMode "locked"; }
              bind "u" { HalfPageScrollUp; }
          }
          entersearch {
              bind "Ctrl c" { SwitchToMode "scroll"; }
              bind "esc" { SwitchToMode "scroll"; }
              bind "enter" { SwitchToMode "search"; }
          }
          renametab {
              bind "esc" { UndoRenameTab; SwitchToMode "tab"; }
          }
          shared_among "renametab" "renamepane" {
              bind "Ctrl c" { SwitchToMode "locked"; }
          }
          renamepane {
              bind "esc" { UndoRenamePane; SwitchToMode "pane"; }
          }
          shared_among "session" "tmux" {
              bind "d" { Detach; }
          }
          tmux {
              bind "left" { MoveFocus "left"; SwitchToMode "locked"; }
              bind "down" { MoveFocus "down"; SwitchToMode "locked"; }
              bind "up" { MoveFocus "up"; SwitchToMode "locked"; }
              bind "right" { MoveFocus "right"; SwitchToMode "locked"; }
              bind "space" { NextSwapLayout; }
              bind "\"" { NewPane "down"; SwitchToMode "locked"; }
              bind "%" { NewPane "right"; SwitchToMode "locked"; }
              bind "," { SwitchToMode "renametab"; }
              bind "[" { SwitchToMode "scroll"; }
              bind "Ctrl b" { Write 2; SwitchToMode "locked"; }
              bind "c" { NewTab; SwitchToMode "locked"; }
              bind "h" { MoveFocus "left"; SwitchToMode "locked"; }
              bind "j" { MoveFocus "down"; SwitchToMode "locked"; }
              bind "k" { MoveFocus "up"; SwitchToMode "locked"; }
              bind "l" { MoveFocus "right"; SwitchToMode "locked"; }
              bind "n" { GoToNextTab; SwitchToMode "locked"; }
              bind "o" { FocusNextPane; }
              bind "p" { GoToPreviousTab; SwitchToMode "locked"; }
              bind "z" { ToggleFocusFullscreen; SwitchToMode "locked"; }
          }
      }
    '';
  };
}
