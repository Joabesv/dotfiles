# ~/.config/fish/config.fish — entrypoint. Keep this file thin.
# Shared setup lives in conf.d/, which fish loads automatically.

if status is-interactive
    # Enable vi mode for fish key bindings (requires fish_vi_key_bindings).
    # fish_vi_key_bindings
end

# Recursively load this file after editing it.
alias reload "source ~/.config/fish/config.fish"
