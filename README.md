# dotfiles

Managed with GNU Stow. `.stowrc` sets the default target to `/home/daniel`.

## Packages

```text
sway -> ~/.config/sway
nvim -> ~/.config/nvim
zsh  -> ~/.zshrc
ly   -> /etc/ly
```

## Install

```sh
stow --no --verbose sway nvim
stow sway nvim
```

## Adopt Existing Files

Use this when files already exist in `$HOME` and should become the repo version:

```sh
stow --no --adopt --verbose sway nvim
stow --adopt sway nvim
git diff
```

## Optional

```sh
stow zsh
sudo stow --target=/ ly
```

## Remove

```sh
stow --delete sway nvim
stow --delete zsh
sudo stow --delete --target=/ ly
```
