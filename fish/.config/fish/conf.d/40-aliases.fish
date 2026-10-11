# Aliases -----------------------------------------------------------------------

# Display
alias cat "batcat --paging=never"
alias ls "eza --icons --group-directories-first"
alias ll "eza --icons --group-directories-first --long --header"
alias la "eza --icons --group-directories-first --long --header --all"
alias tree "eza --tree --icons"

# Navigation
alias .. "cd .."
alias ... "cd ../.."

# Plain alias, not `alias --save`: saving would have fish write a generated
# function file into this repo on every new shell.
alias g "git"
alias gs "git status -sb"

# Networking
alias openports "lsof -i -P -n | grep LISTEN"
alias witr "ss -tulnup"

# Dev
alias testx "poetry run pytest -xvv --disable-warnings"
