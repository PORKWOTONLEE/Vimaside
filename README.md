# Vim As IDE
## Introduction

This script build for Vim, it can automatically deploy plugs, vimrc to vim and makes vim can be used as an IDE. Stably runs in WSL(Debian tested);

required:
- Vim 8.2 (vim-nox or other branch of Vim with python supported)
- Debian 11 (or other dist of Linux)
- Sudo
- Some Patient

## Plugs Installed 

* Tags, File Outline, Definition Jump：gtags ctags tagbar
* Code Complete                      ：coc.nvim
* Fuzzy Search                       : none
* File Viewer                        ：nerdtree
* Title                              ：vim-airline vim-airline-theme
* Tags Manager                       ：vim-gutentags gutentags_plus
* Theme                              : molokai

## Usage

Simply run command like:
```shell
cd VimConfigureDeploy
./Vimconf.sh
```

Update with arg 1:
```shell
./Vimconf.sh 1
```
