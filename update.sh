#!/usr/bin/env sh

# Usage:
#   ./update.sh                # create/update links
#   ./update.sh -n             # dry run
#   ./update.sh -d             # remove links
#   ./update.sh -d -n          # dry run removal


DRYRUN=0
DELETE=0

while [ $# -gt 0 ]; do
    case "$1" in
        -n|--dry-run)
            DRYRUN=1
            ;;
        -d|--delete)
            DELETE=1
            ;;
    esac
    shift
done

# Select stow mode
if [ "$DELETE" -eq 1 ]; then
    STOW_FLAGS="-D"
else
    STOW_FLAGS="-R"
fi
# Determine stow flags
[ "$DRYRUN" -eq 1 ] && STOW_FLAGS="$STOW_FLAGS -n -v"

echo "Running stow with flags: $STOW_FLAGS"

# Custom function to link a file
link_file () {
    SRC="$1"
    DEST="$2"

    if [ "$DELETE" -eq 1 ]; then
        echo "Removing $DEST"
        [ "$DRYRUN" -eq 0 ] && rm -f "$DEST"
    else
        echo "Linking $DEST -> $SRC"
        if [ "$DRYRUN" -eq 0 ]; then
            ln -sfn "$SRC" "$DEST"
        fi
    fi
}

# Stow flat packages (except special cases)
for pkg in */; do
    [ "$pkg" = "config/" ] && continue
    [ "$pkg" = "cursors/" ] && continue
    [ "$pkg" = "icons/" ] && continue
    [ "$pkg" = "vscode/" ] && continue
    stow $STOW_FLAGS -t ~ "${pkg%/}"
done

# Special cases

# > Stow ~/.config packages
for cfg in config/*/; do
    stow $STOW_FLAGS -t ~/.config "$cfg"
done

# > "Stow" contents of icons/.local/share/icons -> ~/.local/share/icons
ICON_DIR="$HOME/.local/share/icons"
mkdir -p "$ICON_DIR"
for file in icons/.local/share/icons/*; do
    [ -f "$file" ] || continue
    ln $([ "$DRYRUN" -eq 1 ] && echo "-sfnv" || echo "-sfn") \
        "$PWD/$file" "$ICON_DIR/$(basename "$file")"
done

# > Stow contents of cursors/.local/share/icons -> ~/.local/share/icons
for dir in cursors/.local/share/icons/*/; do
    [ -d "$dir" ] || continue
    pkg=$(basename "$dir")

    if [ "$DELETE" -eq 1 ]; then
        echo "Removing $ICON_DIR/$pkg"
        [ "$DRYRUN" -eq 0 ] && rm -rf "$ICON_DIR/$pkg"
    else
        echo "Linking $ICON_DIR/$pkg -> $dir"
        [ "$DRYRUN" -eq 0 ] && link_file "$PWD/$dir" "$ICON_DIR/$pkg"
    fi
done

# > CODE OSS

CODEOSS_DIR="$HOME/.config/Code - OSS/User"
VSCODE_SRC="$PWD/vscode"

mkdir -p "$CODEOSS_DIR"

link_file "$VSCODE_SRC/settings.json" "$CODEOSS_DIR/settings.json"
link_file "$VSCODE_SRC/keybindings.json" "$CODEOSS_DIR/keybindings.json"

# snippets (optional)
if [ -d "$VSCODE_SRC/snippets" ]; then
    link_file "$VSCODE_SRC/snippets" "$CODEOSS_DIR/snippets"
fi

# install extensions
if [ "$DELETE" -eq 0 ] && [ -f "$VSCODE_SRC/extensions.txt" ]; then
    echo "Installing Code-OSS extensions"
    if [ "$DRYRUN" -eq 0 ]; then
        xargs -n 1 code --install-extension < "$VSCODE_SRC/extensions.txt"
    fi
fi
