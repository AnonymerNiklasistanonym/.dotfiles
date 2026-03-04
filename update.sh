#!/usr/bin/env sh

# Usage:
#   ./update.sh        # normal mode
#   ./update.sh -n     # dry run

DRYRUN=0

if [ "$1" = "-n" ] || [ "$1" = "--dry-run" ]; then
    DRYRUN=1
    shift
fi

# Common stow flags
STOW_FLAGS="-R"
[ "$DRYRUN" -eq 1 ] && STOW_FLAGS="$STOW_FLAGS -n -v"

echo "Running stow with flags: $STOW_FLAGS"

# Stow flat packages (everything except config/)
for pkg in */; do
    [ "$pkg" = "config/" ] && continue
    stow $STOW_FLAGS -t ~ "${pkg%/}"
done

# Stow ~/.config packages
for cfg in config/*/; do
    stow $STOW_FLAGS -t ~/.config "$cfg"
done
