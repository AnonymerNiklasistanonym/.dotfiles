# dotfiles
 
Automatically generate symbolic links to files in this repository:

```sh
sudo pacman -S stow
```

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
