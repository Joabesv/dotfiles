# Path helpers -------------------------------------------------------------------
# Ordered by specificity: first match wins, so put less common ones first.
for path_entry in \
    "$HOME/.local/share/pnpm" \
    "$HOME/.cargo/bin" \
    "$HOME/.local/bin" \
    "$HOME/go/bin" \
    "$HOME/.bun/bin" \
    "$HOME/.asdf/shims" \
    "$HOME/.proto/bin"
    if test -d "$path_entry"
        fish_add_path --global --move "$path_entry"
    end
end

# Keep cargo's env file last so it cannot clobber the PATH built above.
if test -f "$HOME/.cargo/env.fish"
    source "$HOME/.cargo/env.fish"
end
