# dotfiles

Automatically install applications from a list:

```sh
sudo pacman -S --needed - < pkglist_general.txt
yay         -S --needed - < pkglist_general_aur.txt
```
 
Automatically generate symbolic links to files in this repository:

```sh
sudo pacman -S stow
# Dry run
./update.sh -n
# Actually create symlinks
./update.sh
```

## Other

- Flatpak: https://wiki.manjaro.org/index.php/Flatpak
- Printing: https://wiki.manjaro.org/index.php/Printing

## Documentation

### `stow`

```
dotfiles/
├── vim/
│   └── .vimrc
├── zsh/
│   └── .zshrc
```

From inside `dotfiles` run:

```sh
stow vim
```

This does create the link `~/.vimrc` → `~/dotfiles/vim/.vimrc`.

Each folder is treated as a *package*.

It's possible to apply all or multiple packages at once:

```sh
stow -v */
stow -v vim zsh
```

Using the `R` will refresh symlinks:

```sh
stow -R */
```

And using `n` will not run any actual command (*dry run*):

```sh
stow -n -R */
```

### `pacman`

```sh
# Get all (explicitly) installed packages in a list
pacman -Qqe > pkglist_unfiltered.txt
```
