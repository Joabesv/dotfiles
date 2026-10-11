# Language runtimes --------------------------------------------------------------

# Go
set --global GOPATH "$HOME/go"
set --global GOBIN "$HOME/go/bin"

# pnpm
set --global PNPM_HOME "$HOME/.local/share/pnpm"

# uv (Python)
if test -f "$HOME/.local/bin/env.fish"
    source "$HOME/.local/bin/env.fish"
end

# Railway CLI
if test -f "$HOME/.railway/env.fish"
    source "$HOME/.railway/env.fish"
end
