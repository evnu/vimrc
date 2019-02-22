vimrc
=====

My vim dotfiles. That's it.

Requirements
============

* gvim (this is important! otherwise, `PRIMARY` selection might not work.)
* pathogen
* vundle
* [fzf](https://github.com/junegunn/fzf)
* `python-neovim` (if neovim is to be used on ArchLinux)
* taskwarrior and tasklib

Installation
============

* Clone the repository to `~/.vim` or symlink the clone
* Run
        git submodule init
        git submodule update
* Then run `:PluginInstall`.

Nvim
====

To try this with neovim, link the repository to `~/.config/nvim`.
