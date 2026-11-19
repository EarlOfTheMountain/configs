# Personal configuration files

A small collection of personal configuration files for Vim and a classic X11 desktop. The main entry point is [`.vimrc`](.vimrc): a practical Vim setup with sensible editing defaults, asynchronous language-server support, code formatting, fuzzy finding, and a handful of quality-of-life plugins.

These files are intended as a starting point to inspect and adapt—not as a universal installer. Review the settings and commands before copying them into your home directory.

## Contents

| File | Purpose |
| --- | --- |
| [`.vimrc`](.vimrc) | Vim defaults, plugin list, language-server registrations, mappings, and formatting/search helpers. |
| [`.Xresources`](.Xresources) | Tokyo Night-inspired colors and font/window settings for xterm and urxvt. |
| [`.twmrc`](.twmrc) | Configuration for the twm X11 window manager, including menus, mouse bindings, and window appearance. |

## Vim setup

### Requirements

- Vim with a working `~/.vim` directory and the ability to run external commands.
- [vim-plug](https://github.com/junegunn/vim-plug), used to install the plugins listed in `.vimrc`.
- Optional tools for the features you want to use: language servers, `clang-format`, `fzf`, and `ripgrep`.

The configuration checks whether each language-server executable is available before registering it. Vim itself can still start without those servers, but the corresponding LSP features will not be available.

### Install

1. Clone the repository and copy the Vim configuration into your home directory:

   ```sh
   git clone https://github.com/EarlOfTheMountain/configs.git ~/configs
   cp ~/configs/.vimrc ~/.vimrc
   ```

   Alternatively, review the file and create a symlink if you prefer to keep the repository as the source of truth:

   ```sh
   ln -s ~/configs/.vimrc ~/.vimrc
   ```

2. Install vim-plug if it is not already installed:

   ```sh
   curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
   ```

3. Start Vim and install the configured plugins:

   ```vim
   :PlugInstall
   ```

   The plugins are installed under `~/.vim/plugged`.

4. Restart Vim after plugin installation. Install the external tools for the languages and commands you intend to use (see below).

### Optional tools and language servers

On Debian or Ubuntu, a useful starting point for the general command-line tools is:

```sh
sudo apt install clangd clang-format pipx fzf ripgrep
pipx ensurepath
pipx install basedpyright
```

Open a new shell after `pipx ensurepath` if the `pipx` executable directory is not yet on your `PATH`.

The `.vimrc` recognizes these language servers when their executables are on `PATH`:

| Languages | Executable checked by Vim | Example installation notes |
| --- | --- | --- |
| C, C++, Objective-C, Objective-C++ | `clangd` | Install the `clangd` package for your system. |
| Python | `basedpyright-langserver` | Install with `pipx install basedpyright`. |
| Haskell | `haskell-language-server-wrapper` | Install HLS; [GHCup](https://www.haskell.org/ghcup/) is one commonly used route. |
| JavaScript, JavaScript React, TypeScript, TypeScript React | `typescript-language-server` | Install Node.js/npm (for example, in an nvm-managed environment), then install the server globally. |
| HTML | `vscode-html-language-server` | Provided by the `vscode-langservers-extracted` npm package. |

For JavaScript/TypeScript and HTML language support, install the npm packages in the Node environment you use for development:

```sh
npm install -g typescript typescript-language-server vscode-langservers-extracted
```

The `.vimrc` also contains an example mentioning `typescript@6`; package versions and Node.js setup can change, so choose a TypeScript version compatible with your project and language server. If Vim does not detect a server, check the exact executable name with `command -v <name>` and confirm it is on Vim's `PATH`.

### What the Vim configuration provides

- **Editing:** hidden buffers, persistent undo, a larger command history, autoread, and confirmation prompts for unsaved changes.
- **Display:** absolute and relative line numbers, a persistent status line, sign column, cursor line, mouse support, and scroll margins.
- **Search:** incremental search and highlighted matches, with case-insensitive search that becomes case-sensitive when uppercase characters are entered.
- **Indentation:** four-space tabs as a baseline; filetype-specific rules may override it. `vim-sleuth` can detect indentation already used by a file.
- **Splits:** new horizontal splits open below and vertical splits open to the right.
- **Plugins:** vim-lsp and async completion, comment toggling, NERDTree, Fugitive, GitGutter, and fzf.vim.
- **Language-server support:** hover, navigation, rename, code actions, and diagnostic navigation for the registered servers.
- **Formatting:** a `clang-format`-based mapping for the whole buffer or a selected range.
- **Finding files and text:** fzf.vim's `:Files` and `:Rg` commands, with a default file list that excludes `.git`.

### Key mappings and commands

The leader key is **Space**. The local leader is backslash (no local-leader mappings are currently defined).

| Mapping | Action |
| --- | --- |
| `<leader>w` | Write the current file. |
| `<leader>q` | Quit the current window. |
| `<leader>h` | Clear search highlighting. |
| `<leader>f` (Normal mode) | Format the whole buffer with `clang-format`. |
| `<leader>f` (Visual mode) | Format the selected lines with `clang-format`. |
| `<leader>p` | Open fzf.vim's `:Files` picker. |
| `<leader>/` | Search file contents with fzf.vim's `:Rg` picker. |
| `K` | Show LSP hover information. |
| `gd` | Go to definition. |
| `gr` | Find references. |
| `gi` | Go to implementation. |
| `<leader>rn` | Rename the symbol under the cursor. |
| `<leader>ca` | Request a code action. |
| `[d` / `]d` | Go to the previous / next LSP diagnostic. |

The LSP mappings require the relevant plugin and language server. The formatting mapping requires `clang-format` on `PATH`; despite the mapping name, it invokes `clang-format` for any selected text, so its usefulness depends on the file and formatter configuration. The fzf mappings require the fzf.vim plugin; `:Rg` also relies on `ripgrep` being available.

## X11 configuration

### Xresources

Copy or link `.Xresources` to `~/.Xresources`, then load it into the current X session:

```sh
cp ~/configs/.Xresources ~/.Xresources
xrdb -merge ~/.Xresources
```

It defines a dark Tokyo Night-inspired 16-color palette and settings for both xterm and urxvt, including monospace fonts, a 10-pixel internal border, scrollback, and cursor blinking. Some settings are terminal-specific; install the corresponding terminal and fonts for them to take effect.

### twm

Copy or link `.twmrc` to `~/.twmrc` and start/restart twm for the configuration to take effect. It sets a dark, low-decoration appearance, configures mouse actions and window-operation menus, and includes a Debian application menu. The Debian menu section is marked as automatically generated; avoid hand-editing that section if your system regenerates it.

The menu entries invoke programs such as `urxvt`, `firefox`, and `alsamixergui`; change or remove entries for applications that are not installed on your system.

## Updating

After changing `.vimrc`, restart Vim or source the file with `:source ~/.vimrc`. To update plugins, run `:PlugUpdate`. Changes to Xresources generally need to be reloaded with `xrdb -merge ~/.Xresources`; window-manager changes require restarting twm.

## Notes

- This repository does not include an installation script or automatically install system packages, plugins, or language servers.
- The configuration uses Vim's built-in defaults via `$VIMRUNTIME/defaults.vim` and is written for Vim; other editors may not support all settings or plugins.
- Keep machine-specific paths, package choices, and application commands tailored to your environment.
