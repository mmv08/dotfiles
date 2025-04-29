# ⚙️ My Dotfiles

These dotfiles reproduce my day‑to‑day development environment on **Fedora** (and other Linux distros with minor tweaks) without relying on a heavy framework. Everything lives in a single Git **bare** repository that tracks the files **in‑place** inside `$HOME`, plus a handful of bootstrap scripts.

---

## 🧩 Philosophy

- **Simple & transparent** – just Git and a couple of scripts.
- **Track only what matters** – default config is fine unless I’ve actually changed it.
- **Reproducible** – a one‑liner checks out the dotfiles, another installs the tools.

---

## 📂 Repo layout

| Path                                | Purpose                                                                                                                                                    |
| ----------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `~/.dotfiles`                       | **Bare Git repo** (no working tree)                                                                                                                        |
| `~/.dotfiles-meta/`                 | Meta‑files that don’t belong directly in `$HOME` – e.g. install scripts, docs, images                                                                      |
| `~/.dotfiles-meta/install.sh`       | Main bootstrap script ➜ installs Fedora packages, rustup, nvm, Oh‑My‑Zsh, VS Code, etc.                                                                    |
| `~/.dotfiles-meta/install_scripts/` | Directory containing individual install scripts (install_1password.sh, install_go.sh, install_node.sh, install_rust.sh, install_vscode.sh, install_zsh.sh) |
| dot‑tracked files                   | Any real dotfile you see in `$HOME` (`.zshrc`, `.gitconfig`, `~/.config/Code/User/settings.json`, …)                                                       |

Add new scripts or docs to `~/.dotfiles-meta`, commit them the same way as any other file.

---

## 🚀 Bootstrap on a fresh machine

```bash
# 1️⃣  Clone the bare repo into ~/.dotfiles
git clone --bare git@github.com:mmv08/dotfiles.git $HOME/.dotfiles

# 2️⃣  Create the helper alias and check out tracked files
alias dot='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dot checkout     # restores .zshrc, .gitconfig, etc.

dot config --local status.showUntrackedFiles no  # hide noisy untracked entries

# (Optional) add the alias permanently to ~/.zshrc

# 3️⃣  Run the main bootstrap script (installs packages & runtimes)
bash ~/.dotfiles-meta/install.sh

Open a new shell so PATH changes take effect (Rust, nvm, Go, etc.).

---

## 🛠️ Daily workflow

| Task              | Command                                               |
| ----------------- | ----------------------------------------------------- |
| Track a file      | `dot add ~/.vimrc && dot commit -m "Add vimrc"`       |
| Update everything | run `install.sh` again – idempotent                   |
| Push changes      | `dot push`                                            |

---

## 🔄 Keeping scripts up‑to‑date

- **`install.sh`** – package list lives in a simple Bash array so adding/removing tools is one edit.

---

## 🪄 Extending this setup

- Create a devcontainer / Codespaces file to test the bootstrap in CI.
```
