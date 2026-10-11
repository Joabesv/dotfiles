# proto (https://github.com/catenacyber/proto) — Kubernetes dev tooling.
# `proto activate fish --export` must run on every directory change so the
# active cluster namespace stays in sync with $PWD.

if not type -q proto
    return 0
end

function _proto_activate_hook --on-variable PWD
    proto activate fish --export | source
end

set --global PATH "$HOME/.proto/bin" $PATH
set --global __ORIG_PATH $PATH

_proto_activate_hook
