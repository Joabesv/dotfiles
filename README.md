# dotfiles

Personal configuration for a fish + Ghostty + VS Code + Zed setup on Linux (Zorin OS),
alongside the AI coding tools (Claude Code, OpenCode, Herdr).

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
| `zed`      | `~/.config/zed`                 | `settings.json`, `keymap.json`, `tasks.json`      |
| `herdr`    | `~/.config/herdr`               | `config.toml` (UI prefs only)                    |
| `opencode` | `~/.config/opencode`            | `opencode.json` (MCP servers), `skills/`          |
| `claude`   | `~/.claude`                     | `settings.json` (sanitized — see below)          |
| `agents`   | `~/.agents`                     | `AGENTS.md`, `skills/`, `.skill-lock.json`        |

The `agents` package is the important one: `~/.agents/` holds your code-style
guide and all 58 agent skills, and `~/.config/opencode/AGENTS.md` plus
`~/.claude/CLAUDE.md` are symlinks into it. Losing it costs you your
instructions and every skill, so it is versioned here.

Because every package shares `.config`, Stow *folds* that directory and links
each package's own subtree into it rather than replacing `.config` wholesale.
The `claude` package targets `~/.claude` directly, so Stow folds that directory
too and links only `settings.json`, leaving your session history and credentials
in place.

## Secrets

**This repo is public.** Nothing here may contain a credential, and several files
on this machine were deliberately left out of it:

| Excluded | Why |
| --- | --- |
| `gh/hosts.yml` | GitHub CLI OAuth tokens |
| `github-copilot/apps.json` | Copilot OAuth token |
| `claude/.credentials.json`, `claude/.claude.json` | Account + OAuth state |
| `opencode/service.json` | Service password |
| `zedis/redis-servers.toml` | Redis **production** password |
| `squarecloud/config.json` | Provider auth token |
| `axiom-sre/config.toml` | Axiom / Grafana API tokens |

`.gitignore` lists these by name as a second line of defence, so an accidental
`git add -A` cannot commit them.

Two files are **sanitized** rather than excluded:

- `claude/.claude/settings.json` — the `autoMode.environment` block was removed.
  It described the private work repo, internal domains, a production bucket and
  the names of CI secrets, which is an infrastructure map rather than
  configuration. Your original is preserved at `secrets/claude-settings.json`
  (gitignored). Bucket names in `autoMode.soft_deny` were generalised for the
  same reason.
- `opencode/.config/opencode/opencode.json` — the Postgres `connectionString` now
  reads `{env:OPENCODE_POSTGRES_URL}`. Set that variable in your shell to use the
  `opencode-postgres` plugin.

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
- `functions/` holds one file per function, because fish autoloads by filename.
- Generated files stay out: the herdr plugin and the Claude `SessionStart` hook
  are installed by herdr and overwritten on update, so they are not versioned
  even though `settings.json` references the hook path. `opencode/cli.json` is
  excluded too — the TUI rewrites it on every launch, so stowing it would make
  the repo dirty on each run. Set your theme there with `opencode theme`.

## Environment variables

Set these in your shell (not in this repo) if you use the corresponding feature:

| Variable | Used by |
| --- | --- |
| `OPENCODE_POSTGRES_URL` | `opencode-postgres` plugin in `opencode.json` |

## What this repo is not

This is declarative config, not a backup. Reproducing a machine still requires
reinstalling software and restoring data that is deliberately not here:

- **Packages** are not tracked. Nothing records the ~330 manually-installed apt
  packages or the 15 flatpaks, so a fresh machine means re-deriving them:
  ```bash
  apt-mark showmanual > apt.txt
  flatpak list --app > flatpak.txt
  code --list-extensions > vscode-extensions.txt
  ```
- **Editor extensions** are not tracked (VS Code and Zed keep their own cloud
  settings backup).
- **Runtime state** stays out by design: `fish_variables`, `opencode/cli.json`,
  herdr logs and sockets, and the ~200 MB of Claude session history.
- **Your projects in `~/dev/`** live in their own repositories and are backed up
  separately.
- **Version pins** are not tracked. There is no `.tool-versions`, so asdf
  resolves `java` to whatever was current. `proto` manages the other runtimes.

Secrets live in 1Password, never here — see [`secrets/1password.md`](secrets/1password.md)
for which item each tool expects and the `op read` commands to restore them.

## Dependencies

The configs assume these tools exist. Missing ones degrade gracefully where
guarded (`starship`, `proto`, `asdf`) but the aliases in `40-aliases.fish` need
`eza` and `bat` to be installed.
