# Dotfiles setup

These dotfiles configure Zsh, Neovim, Ghostty, WezTerm, and shared agent skills.
The installer uses Homebrew for development tools on both macOS and Linux,
including Lazygit, PHP, Composer, and Neovim. NVM manages Node LTS.

## Install on Ubuntu

Install the system tools Homebrew needs:

```bash
sudo apt update
sudo apt install build-essential procps curl file git
```

Clone the repository and run the installer as your normal user:

```bash
git clone git@github.com:rushjs1/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
# While the Linux PR is unmerged:
git switch codex/linux-prep
bash install.sh
```

Do not run the installer with sudo. Homebrew may request elevated access during
its own setup. Downloads can take several minutes without much terminal output.
Wait for `Completed`, or inspect any error before proceeding.

Existing configs are moved to `~/.dotfiles-backups/<timestamp>/` before creating
symlinks. Re-running the installer preserves links that already match.
Laravel Valet is macOS-only; leave `INSTALL_VALET` unset on Ubuntu.

## Make Zsh the default shell

The installer installs Zsh but does not change your login shell. Try it first:

```bash
/home/linuxbrew/.linuxbrew/bin/zsh
```

Use `exit` to return to your previous shell. To make it the default, register
its path once and use `chsh`:

```bash
zsh_path=/home/linuxbrew/.linuxbrew/bin/zsh
# If Homebrew was installed in ~/.linuxbrew, use that bin/zsh path instead.
grep -qxF "$zsh_path" /etc/shells || printf '%s\n' "$zsh_path" | sudo tee -a /etc/shells
chsh -s "$zsh_path"
```

Save your work, then log out and back in (or restart). In a new terminal,
`echo "$SHELL"` should show the chosen Zsh path. `p10k configure` starts the
prompt setup wizard.

## Ghostty and fonts on Linux

Install Ghostty separately using [its installation instructions](https://ghostty.org/docs/install/binary).
The installer links its config, but the Brewfile only installs GUI applications
and fonts on macOS. Install MesloLGS NF from
[Powerlevel10k's font instructions](https://github.com/romkatv/powerlevel10k#fonts),
then reopen Ghostty. Check discovery with `fc-match "MesloLGS NF"`.

Ghostty follows your default login shell. Avoid forcing `/bin/zsh`: Homebrew's
Linux Zsh normally lives at `/home/linuxbrew/.linuxbrew/bin/zsh`.

The config selects a steady block cursor and disables shell cursor changes.
Some Linux desktop launchers pass `--shell-integration-features=ssh-env`, which
overrides that setting. If you still see a bar cursor:

1. Copy the installed `com.mitchellh.ghostty.desktop` file from
   `/usr/share/applications/` into `~/.local/share/applications/`.
   If a user copy already exists, edit that copy instead.
2. In each `Exec=` line, replace `--shell-integration-features=ssh-env` with
   `--shell-integration-features=ssh-env,no-cursor`. Preserve other arguments.
3. Fully quit Ghostty and reopen it from the app launcher.

This keeps the change in your user account. The installer does not edit desktop
launchers automatically. Revisit the user override if Ghostty's packaged launcher
changes in a future update.

## Verify the setup

In a new Zsh terminal, run:

```bash
zsh --version
nvim --version
node --version
lazygit --version
```

Installer regression checks use a temporary home directory and mocked commands:

```bash
PYTHONDONTWRITEBYTECODE=1 python3 -m unittest discover -s tests -v
bash -n install.sh
zsh -n .zshrc
```

The Linux branch was installed on an Ubuntu PC on October 12, 2026. The installer
reported `Completed`; Zsh loaded the config and exposed Neovim and Node. Ghostty
started successfully after removing its hardcoded shell path. Lazygit was missing
from that original package list and is included now. The launcher cursor
workaround was applied, but its visual result still needs confirmation.
