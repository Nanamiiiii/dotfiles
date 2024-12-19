# Reference: https://github.com/elecdeer/dotfiles/blob/c0bc7c6b4d54d3e3ac5514f64476d6b23826a7f0/plugins/on-demand-completion/on-demand-completion.plugin.zsh
on_demand_completion() {
  local cmd_name=$1
  local completion_command="${2:-${cmd_name} completion zsh}"
  local function_name="_${cmd_name}"

  if ! command -v "$cmd_name" &> /dev/null; then
    return
  fi

  eval "function $function_name() {
    unfunction '$function_name'
    eval \"\$(eval $completion_command)\"
    \$_comps[$cmd_name]
  }"

  compdef $function_name $cmd_name
}
