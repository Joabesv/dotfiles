#!/usr/bin/env bash
# Install the dotfiles with GNU Stow.
#
# Safe to re-run: each step is idempotent and refuses to clobber existing files.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STOW_TARGET_DIR="${STOW_TARGET_DIR:-$HOME}"
PACKAGES=(fish git gh ghostty btop bat vscode lazygit fusuma)

require_stow() {
    if command -v stow >/dev/null 2>&1; then
        return 0
    fi

    echo "error: GNU Stow is required but not installed." >&2
    echo "  Debian/Ubuntu: sudo apt-get install -y stow" >&2
    echo "  Fedora:        sudo dnf install -y stow" >&2
    echo "  Arch:          sudo pacman -S stow" >&2
    echo "  macOS:         brew install stow" >&2
    exit 1
}

report_conflict() {
    local conflicting_path="$1"
    echo "error: '$conflicting_path' already exists and is not managed by stow." >&2
    echo "  Move it aside, then re-run this script:" >&2
    echo "    mv '$conflicting_path' '$conflicting_path.bak'" >&2
    exit 1
}

backup_before_stow() {
    local package_name="$1"
    local relative_path="$2"
    local source_path="$DOTFILES_DIR/$package_name/$relative_path"
    local target_path="$STOW_TARGET_DIR/$relative_path"

    if [[ ! -e "$target_path" && ! -L "$target_path" ]]; then
        return 0
    fi

    # Resolve the target through any parent symlinks. When a whole directory was
    # folded into a single symlink (stow links .config/fish, not each file),
    # the files inside look like ordinary files but still belong to this repo.
    if is_managed_by_this_repo "$target_path"; then
        return 0
    fi

    if [[ -L "$target_path" ]]; then
        echo "warning: $target_path symlinks outside this repo."
        echo "         Repointing it at $source_path."
        rm "$target_path"
        return 0
    fi

    report_conflict "$target_path"
}

# True when the path resolves to a location inside $DOTFILES_DIR.
is_managed_by_this_repo() {
    local candidate="$1"
    if [[ ! -e "$candidate" ]]; then
        return 1
    fi
    local resolved_path
    resolved_path="$(readlink -f "$candidate")"
    [[ "$resolved_path" == "$DOTFILES_DIR"/* ]]
}

# A regular file standing where stow needs to descend into a directory blocks
# the whole package. Real directories are fine: stow folds shared parents
# (every package here lives under .config) instead of replacing them.
check_parent_directory_is_free() {
    local package_name="$1"
    local relative_path="$2"
    local parent_relative
    parent_relative="$(dirname "$relative_path")"

    while [[ "$parent_relative" != "." && "$parent_relative" != "/" ]]; do
        local parent_path="$STOW_TARGET_DIR/$parent_relative"
        if [[ -e "$parent_path" && ! -d "$parent_path" ]]; then
            report_conflict "$parent_path"
        fi
        parent_relative="$(dirname "$parent_relative")"
    done
}

# Yield every leaf file inside the package. Directories are deliberately
# excluded: when several packages share a parent directory (all of them live
# under .config), stow "folds" that directory and links only the leaf files.
list_package_targets() {
    local package_dir="$1"
    (
        cd "$package_dir"
        find . -mindepth 1 -type f -printf '%P\n'
        find . -mindepth 1 -type l -printf '%P\n'
    )
}

require_stow

cd "$DOTFILES_DIR"

for package_name in "${PACKAGES[@]}"; do
    package_dir="$DOTFILES_DIR/$package_name"
    if [[ ! -d "$package_dir" ]]; then
        echo "skipping '$package_name': directory not found."
        continue
    fi

    while IFS= read -r relative_path; do
        check_parent_directory_is_free "$package_name" "$relative_path"
        backup_before_stow "$package_name" "$relative_path"
    done < <(list_package_targets "$package_dir")

    stow --dir="$DOTFILES_DIR" --target="$STOW_TARGET_DIR" --stow "$package_name"
    echo "stowed: $package_name"
done

echo
echo "Done. Open a new shell (or run 'exec fish') to pick up the changes."
