# Tool configuration -------------------------------------------------------------

# Prompt (starship)
if type -q starship
    starship init fish | source
end

# bat
set --universal BAT_THEME "Catppuccin Mocha"
set --universal BAT_PAGER "less --fringe --quit-if-one-screen"

# fzf
if type -q fdfind
    set --universal FZF_DEFAULT_COMMAND "fdfind --type f --exclude .git"
end
set --universal FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
set --universal FZF_ALT_C_COMMAND "$FZF_DEFAULT_COMMAND"

# Git delta as the diff pager, but only if it is installed.
# uncomment after `cargo install git-delta`:
# set --global GIT_PAGER "delta"

# less keeps colors in its pipe output
set --export LESS "-R -F -X"
