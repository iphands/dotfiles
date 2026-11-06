# Emacs config

This directory is the **whole** tracked Emacs setup: authored config only.
Packages are not vendored. They are declared in `init.el` and downloaded from
the package archives by `emacs-bootstrap`.

```
emacs/                        tracked in git
  early-init.el               runs before package.el: version guard, archives, GC
  init.el                     all config + one use-package block per package
  README.md                   this file
  lisp/                       (optional, doesn't exist yet) extra authored elisp

~/.emacs.d/                   a REAL local directory, never tracked
  early-init.el -> <repo>/emacs/early-init.el
  init.el       -> <repo>/emacs/init.el
  lisp          -> <repo>/emacs/lisp        (only if it exists)
  elpa/                       downloaded packages (+ elpa/gnupg keyring)
  eln-cache/                  native-compiled code
  custom.el                   anything Customize saves
  ido.last, recentf, smex-items, transient/, tramp, ...   per-host state
```

Emacs writes only into `~/.emacs.d`, and the only things in there that come
from the repo are the symlinks. Anything Emacs creates can't land in git.

## New machine

```sh
git clone <dotfiles> ~/prog/dotfiles
cd ~/prog/dotfiles
./init              # creates ~/.emacs.d and the symlinks (among everything else)
emacs-bootstrap     # downloads all declared packages, about 1 minute
```

You can skip `emacs-bootstrap` and just start Emacs: missing packages install
on the first start. The script is the non-interactive version. It prints
progress, and its exit code says whether every package installed.

Needs **Emacs 30+**. `early-init.el` refuses to load on anything older,
because built-in `use-package` is required.

## Day to day

| Task | How |
|---|---|
| Add a package | Add `(use-package foo)` to `init.el`, then restart or run `emacs-bootstrap` |
| Configure a package | Put it inside its block: `:hook`, `:mode`, `:bind`, `:custom`, `:init`, `:config` |
| Remove a package | Delete its block, then `emacs-bootstrap --prune` |
| Upgrade everything | `emacs-bootstrap --upgrade` (or `M-x package-upgrade-all`) |
| Get a host back in sync | `git pull && emacs-bootstrap` |
| Use a built-in library | `(use-package foo :ensure nil ...)`, so nothing is downloaded |
| Package name differs from the feature | `(use-package feature :ensure package-name)` |

Settings made through `M-x customize` land in the local `~/.emacs.d/custom.el`
and stay on that host. If a setting should follow you to every machine, move
it into `init.el` as `setq` or `:custom`.

## How it works

### `init.el`

- **`custom-file` is `~/.emacs.d/custom.el`.** package.el records every
  install in `package-selected-packages` through Customize. If Customize wrote
  into `init.el`, every `package-install` would rewrite tracked config. That
  is how the old `.emacs` ended up listing packages that were never installed.
- **`use-package-always-ensure t`.** Every `use-package` block installs its
  package if it's missing. If the package can't be found in the cached index,
  use-package refreshes the archives first. A failed install is a warning,
  not a fatal error, so init still finishes.
- **`use-package-always-defer t`.** Nothing is `require`d at startup.
  Packages load through their own autoloads, or through the triggers in their
  block (`:mode`, `:hook`, `:bind`). A block with no trigger loads only when
  one of the package's autoloaded commands runs. If something really has to
  load at startup, add `:demand t`.
- Your own functions (`tabson`/`tabsoff`, the per-mode `C-x a` formatters,
  `myfzf`, the mode hooks) sit next to the package they belong to.

### `early-init.el`

- Errors out on Emacs older than 30.
- Archives are `gnu`, `nongnu` and `melpa`, all over **https**. MELPA packages
  are unsigned, so plain http would let anyone on the network path swap one.
- **There are deliberately no `package-archive-priorities`.** With
  gnu > nongnu > melpa, about 35 packages resolved to old tagged releases
  (go-mode 1.6.0, typescript-mode 0.4) instead of MELPA snapshots. Without
  them, the highest version wins, which in practice means MELPA, as it always
  was.
- Raises the GC threshold during startup and restores it afterwards.

### `bin/emacs-bootstrap`

```
emacs-bootstrap            install whatever is missing (no network if nothing is)
emacs-bootstrap --upgrade  refresh archives and upgrade everything
emacs-bootstrap --prune    delete installed packages nothing declares or needs
```

1. Reads `init.el` and collects every **top-level** `(use-package NAME ...)`
   form, skipping `:ensure nil`. It also understands `:ensure other-name` and
   `:ensure (name . archive)`.
2. If anything is missing (or for `--upgrade`), it refreshes the archive
   index first. A stale cached index can name a version the archive no longer
   serves, and that download 404s.
3. Loads `early-init.el` and `init.el` in batch mode. That is the same code
   path as a real start, so the run also proves init loads cleanly.
4. Exits **nonzero** if any declared package still isn't installed, and names
   it.

Environment: `EMACS` (default `emacs`) and `EMACS_DIR` (default `~/.emacs.d`).

The GNU ELPA signing key needs no setup. On the first refresh, Emacs imports
its bundled `etc/package-keyring.gpg` into the fresh `elpa/gnupg`
automatically, batch mode included.

### `./init` (`install_emacs`)

- Removes a `~/.emacs` symlink, or moves a real `~/.emacs` into
  `~/.dotfiles_backup/<stamp>/`. **Emacs reads `~/.emacs` before
  `~/.emacs.d/init.el`**, so any leftover silently shadows this config.
- **Legacy layout** (`~/.emacs.d` is a symlink to this repo's `.emacs.d`): it
  replaces the link with a real directory and copies over local state
  (history, recentf, smex, tramp, `transient/`, ...). It does **not** copy
  `elpa/`, `auto-save-list/`, `eln-cache/`, `*~` or `.#*`. The whole old
  directory is moved to `~/.emacs.d.legacy-<stamp>` and nothing is deleted;
  remove it yourself once things work.
- If `~/.emacs.d` is a symlink pointing anywhere else, it warns and leaves it
  alone.
- (Re)creates the symlinks. Running it again is safe.

## Migrating a host that has the old layout

Before this change, `~/.emacs.d` was a symlink into the repo, and `elpa/` was
tracked in git.

```sh
# stop any running Emacs daemon first: its packages are about to move
cd ~/prog/dotfiles
git pull            # removes the tracked elpa/ files from the old ~/.emacs.d
./init              # real ~/.emacs.d, state carried over, old dir kept as .legacy-*
emacs-bootstrap
```

Run the three steps together. Between the pull and `./init`, a freshly
started Emacs on that host has neither a config nor packages.

## Tests

| Script | Needs | Checks |
|---|---|---|
| `tests/emacs-test` | git only, runs anywhere | nothing tracked under `.emacs.d/`; `emacs/` holds only `.el` files plus this README; no `.elc`/`.eln`/`custom.el`/`elpa/` anywhere; `./init` doesn't link `.emacs`/`.emacs.d` wholesale; `use-package-always-ensure` and `custom-file` set; no `package-selected-packages` in code; no http archives |
| `tests/emacs-smoke` | Emacs 30+ and network | in a fresh temp `HOME`: bootstrap from nothing, keyring imported, second run does no installs and no network, about 20 file types open in the right major mode, `C-x a` is the right command per mode, nothing written back into the repo |

```sh
tests/emacs-test
tests/emacs-smoke                       # ~1 min, full download
KEEP_HOME=/tmp/emacs-home tests/emacs-smoke   # reuse a HOME for fast reruns
```

Nothing runs these automatically.

## Gotchas

- **`emacs` in an interactive shell is `emacsclient`** (alias in `.bashrc`).
  Scripts don't see aliases, so `emacs-bootstrap` gets the real binary. If you
  type `emacs --batch ...` by hand, use `command emacs`.
- **Only top-level `use-package` forms count.** A block wrapped in `when`,
  `with-eval-after-load` or similar still installs at startup, but
  `emacs-bootstrap` won't see it, so it won't be checked or protected from
  `--prune`.
- **No version pinning.** Every host gets whatever MELPA serves on the day it
  installs or upgrades, so hosts can drift. If that ever causes trouble,
  switching to elpaca or straight.el with a lockfile is a small change from
  here, since the `use-package` blocks carry over almost unchanged.
- `.php`/`.inc` map to `hack-mode`, which isn't declared or installed, so
  those files open in `fundamental-mode`. This is the existing behavior, kept
  on purpose.
- The jsx tweak advising `web-mode-highlight-part` never fires: current
  web-mode no longer defines that function. It's kept, with a comment, until
  someone decides what to do with it.
- `.git` still holds the old vendored `elpa/` in its history (about 162 MB).
  Reclaiming that would take a history rewrite and a force-push. Tag
  `elpa-fork-final` (e7e30bc7) points at the last commit with the full old
  tree.

## Why it's built this way

`./init` used to symlink the repo's `.emacs.d` to `~/.emacs.d`, which made
the git worktree Emacs's state directory. That brought in 906 tracked elpa
files (82 MB), plus history files, LSP sessions, cookies and a GnuPG home,
all travelling between hosts through `git pull`. Several commits tried to
defend that layout with a whitelist `.gitignore` and a guard test. Making
`~/.emacs.d` a local directory removes the cause instead.

While porting, the old `package-selected-packages` list (82 entries) became 64
`use-package` blocks:

- **Removed, gone from the archives or never installed:** highline, lineno,
  markdown-mode+, puppetfile-mode, company-box, company-c-headers,
  company-cmake, flymake-shellcheck, helm-git
- **Removed, built in now:** eglot, eldoc
- **Removed, dead upstream or superseded:** lsp-python-ms, racer,
  flow-minor-mode, lsp-pyre, flycheck-pyre, company-go, go-eldoc
- **Removed, pure dependencies:** epc, json-rpc
- **Added explicitly:** flycheck (it was configured, but only arrived as a
  dependency) and markdown-mode
