# dotfiles

Personal configuration for a fish + Ghostty + VS Code dev setup on Linux (Zorin OS).

Managed with [GNU Stow](https://www.gnu.org/software/stow/) — every file lives in
this repo and is symlinked into place, so editing a config in `~/.config` edits
the repo directly.

## Layout

Each package is a self-contained tree that mirrors the path it will occupy
under `$HOME`. So `git/.config/git/config` becomes `~/.config/git/config`.

| Package    | Target                          | Contents                                        |
| ---------- | ------------------------------- | ----------------------------------------------- |
| `fish`     | `~/.config/fish`                | `config.fish` entrypoint, `conf.d/`, `functions/` |
| `git`      | `~/.config/git`                 | `config` (aliases), `ignore`                     |
| `gh`       | `~/.config/gh`                  | GitHub CLI preferences                           |
| `ghostty`  | `~/.config/ghostty`             | Terminal emulator config + Catppuccin theme      |
| `btop`     | `~/.config/btop`                | Process viewer config                            |
| `bat`      | `~/.config/bat`                 | Syntax highlighting themes                       |
| `vscode`   | `~/.config/Code/User`           | `settings.json`, `keybindings.json`, snippets    |
| `lazygit`  | `~/.config/lazygit`             | Git TUI config                                   |
| `fusuma`   | `~/.config/fusuma`              | Touchpad gesture shortcuts                       |

Because every package shares `.config`, Stow *folds* that directory and links
each package's own subtree into it rather than replacing `.config` wholesale.

## Install

```bash
sudo apt-get install -y stow   # GNU Stow
git clone git@github.com:Joabesv/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./install.sh
```

`install.sh` is idempotent. It refuses to overwrite a real file that it did not
create — move the file aside (the script tells you the exact command) and re-run.

## Everyday use

Re-stow everything after pulling:

```bash
cd ~/dotfiles && git pull && ./install.sh
```

Un-stow a single package (GNU Stow calls this `--delete`):

```bash
stow --dir=~/dotfiles --target=~ --delete fish
```

Edits: change the file wherever is more convenient. Because both paths are the
same inode, there is nothing to copy or sync back.

## Machine-specific settings

`git/.config/git/config` contains a real `user.email`, so the repo is not
anonymised by default. It is published as-is.

`python.defaultInterpreterPath` is deliberately **not** set. It previously pointed
at an absolute `~/.proto/bin/python`, which breaks on any other machine. VS Code
resolves the interpreter from `PATH` on its own, and `proto` already puts its
Python shims there. Note that the Python extension only honours this setting for
a workspace before an interpreter has been selected, so a stale value is often
inert anyway.

## Conventions

- `conf.d/` files are prefixed with a numeric ordering (`10-`, `20-`, …) because
  fish loads them alphabetically. Paths before runtimes before tools before
  aliases.
- Paths use `$HOME`, never a hardcoded username, so this repo works on any machine.
- Anything that reads a version manager (`asdf`, `proto`) is guarded with
  `type -q` so a missing tool cannot break shell startup.
- `gh/hosts.yml` is gitignored: it holds OAuth tokens.

## Dependencies

The configs assume these tools exist. Missing ones degrade gracefully where
guarded (`starship`, `proto`, `asdf`) but the aliases in `40-aliases.fish` need
`eza` and `bat` to be installed.
