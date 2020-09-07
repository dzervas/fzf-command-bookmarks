# FZF Command Bookmarks

This is a kind replacement of the deceased [marker](https://github.com/pindexis/marker).
It uses `fzf` and `highlight` - its only requirements.

It lets you add a command in the bookmarks and then search through your bookmarks.
Never forget

![Screenshot of bookmark show](screenshot_show.png)

## Installation

For ZSH you can use any plugin manager, for example for [antigen](https://github.com/zsh-users/antigen)
put in your `.zshrc` before `antigen apply`:

```bash
antigen bundle dzervas/fzf-command-bookmarks
```

For bash or if you don't want to use a plugin manager with ZSH, you can just
clone the project somewhere cozy and source the script from your `.bashrc` or
`.zshrc`:

```bash
source ~/Lab/fzf-command-bookmarks/fzf-command-bookmarks.sh
```

## Configuration

```bash
# Shortcut to trigger the bookmark addition functionality
export FZF_COMMAND_BOOKMARKS_ADD="C-k"
# Shortcut to trigger the bookmark showing functionality
export FZF_COMMAND_BOOKMARKS_SHOW="C-@"
# Manages where the bookmarks are kept
export FZF_COMMAND_BOOKMARKS_FILE=~/.fzf-command-bookmarks.txt
```

If you want to change any of the above, just add a line to change the
corresponding environment variable **AFTER** the line that you `source` the
script. For example, in your `.bashrc`:

```bash
source ~/Lab/fzf-command-bookmarks/fzf-command-bookmarks.sh
# Let's change the file path
export FZF_COMMAND_BOOKMARKS_FILE=~/.my-bookmarks.txt
```

The bookmarks are saved in a file (`~/.fzf-command-bookmarks.txt` by default,
managed by `FZF_COMMAND_BOOKMARKS_FILE`) in the following notation:

```
my awesome command##This is the title
```

---

There is currently both bash and zsh support but more tests should be conducted
(old versions, weird setups, etc.). I don't use fish, so feel free to open an MR.
