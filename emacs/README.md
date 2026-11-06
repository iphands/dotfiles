# Emacs config

This directory is the **whole** tracked Emacs setup. Packages are not
vendored: the repo tracks *which* packages you use, as plain lists that
`M-x list-packages` writes for you, and every machine downloads them.

```
emacs/                          tracked in git
  early-init.el                 runs before package.el: version guard, archives, GC
  init.el                       all config; use-package blocks only CONFIGURE
  packages.el                   SHARED package list - every machine installs these
  lisp/my-packages.el           the machinery behind the lists
  dot-emacs.el                  the ~/.emacs signpost (see below)
  README.md                     this file
host/<host>/emacs/
  packages-local.el             extras for that one machine (optional, tracked)

~/.emacs                        -> <repo>/emacs/dot-emacs.el: comments on where
                                   things are and how to use them, plus one line
                                   that loads ~/.emacs.d/init.el
~/.emacs.d/                     a REAL local directory, never tracked
  early-init.el, init.el, lisp  -> symlinks into <repo>/emacs/
  packages-local.el             -> <repo>/host/<host>/emacs/packages-local.el
  elpa/                         downloaded packages (+ elpa/gnupg keyring)
  eln-cache/, custom.el, ido.last, recentf, transient/, ...   per-machine state
```

Emacs writes only into `~/.emacs.d`. The only files it changes in the repo
are the package lists, and that is on purpose: they're how a
`list-packages` install reaches your other machines.

### `~/.emacs` is a signpost, not config

Emacs loads **either** `~/.emacs` **or** `~/.emacs.d/init.el`, never both: if
`~/.emacs` exists, `init.el` is skipped. So `~/.emacs` (a link to
`emacs/dot-emacs.el`) is mostly comments: a map of where everything lives
and a cheat sheet of the commands. Its single line of code loads
`~/.emacs.d/init.el`. **Don't put config in it, and don't trim it down to
comments only**: without that line Emacs starts with no config at all, and
no error tells you why. Both `tests/emacs-test` and `tests/emacs-smoke`
check for this.

## New machine

```sh
git clone <dotfiles> ~/prog/dotfiles
cd ~/prog/dotfiles
./init        # links everything, then syncs packages (~1 minute the first time)
```

Needs **Emacs 30+**. `early-init.el` refuses to load on anything older.

## Day to day

| Task | How |
|---|---|
| Install a package | `M-x list-packages`, `i` then `x`. The name lands in `emacs/packages.el`: commit it |
| Remove a package | `M-x list-packages`, `D` then `x`. The name leaves whichever list had it: commit |
| Upgrade | `U` then `x` in list-packages. The lists don't change (versions aren't tracked) |
| Make a package this machine only | `M-x my/package-make-local`, then commit `host/<host>/emacs/packages-local.el` |
| Share a machine-only package | `M-x my/package-make-shared`, then commit both lists |
| Sync another machine | `git pull && ./init` (or just `emacs-bootstrap`) |
| Preview a sync | `emacs-bootstrap --dry-run` |
| Upgrade everything from the shell | `emacs-bootstrap --upgrade` |
| Configure a package | Add or edit its `use-package` block in `init.el` |
| Clean up config for a removed package | `M-x my/package-trim-config` |

`git status` showing `emacs/packages.el` as modified is your reminder to
commit. Dependencies never appear in the lists: package.el installs them as
needed and removes them once nothing needs them.

## How it works

### The lists (`lisp/my-packages.el`)

package.el already keeps a list of the packages you installed on purpose,
`package-selected-packages`, and normally saves it through Customize. All of
those saves go through one internal function,
`package--save-selected-packages-1`. my-packages overrides that function:

- At startup, `package-selected-packages` = shared list ∪ this machine's list.
- On every change (an install or delete, from the UI or from Lisp), anything
  already in this machine's list stays there, everything else goes to the
  shared list, and a file is rewritten only if its content changed.
- Files are written in one canonical form: header comment, sorted, one name
  per line. Diffs are one line per package, and concurrent installs on two
  machines almost always merge cleanly.
- `~/.emacs.d/packages-local.el` is followed through its symlink, even a
  dangling one. The first `my/package-make-local` creates
  `host/<host>/emacs/packages-local.el` in the repo.

**Safety.** If a list can't be read (git conflict markers, a broken edit, or
anything that isn't one list of names), Emacs shows an error at startup and
then refuses to write either list. `emacs-bootstrap` exits without changing
anything. `package-autoremove` refuses to run with unreadable or empty lists,
because otherwise it would offer to delete every package. Fix the file, then
restart Emacs.

### Config blocks (`init.el`)

`use-package` blocks exist only for packages that need configuring (16 of
them). Installing is the lists' job, so there's no `:ensure`.
`use-package-always-defer t` keeps loading lazy.

Every block automatically gets `:if (my/package-available-p 'NAME)`, so a
block whose package isn't installed switches itself off: no autoloads, no
`auto-mode-alist` entries, no errors. At startup Emacs warns about two cases:

- **Listed but not installed**: you pulled but haven't synced. Run
  `emacs-bootstrap` or `./init`.
- **In neither list**: the package was removed, but its config is still in
  `init.el`. `M-x my/package-trim-config` shows each such block highlighted
  and deletes it if you answer `y`, along with comment lines directly above
  it. It leaves the `my-*` helper functions alone and names them in a message.
  git is the undo.

The automatic check is skipped for blocks that have their own
`:if`/`:when`/`:unless`, a `:load-path`, or `:ensure nil`. Use `:ensure nil`
for built-in features that aren't packages, e.g.
`(use-package sh-script :ensure nil ...)`.

Settings made through `M-x customize` land in the local `~/.emacs.d/custom.el`
and stay on that machine. If a setting should follow you everywhere, move it
into `init.el`.

### `early-init.el`

- Errors out on Emacs older than 30.
- Archives are `gnu`, `nongnu` and `melpa`, all over **https**. MELPA packages
  are unsigned, so plain http would let anyone on the network path swap one.
- **There are deliberately no `package-archive-priorities`.** With them, about
  35 packages resolved to old tagged releases (go-mode 1.6.0, typescript-mode
  0.4) instead of MELPA snapshots. Without them the highest version wins,
  which in practice means MELPA.
- Raises the GC threshold during startup and restores it afterwards.

### `bin/emacs-bootstrap` (the sync)

```
emacs-bootstrap            install what the lists name, remove what they dropped
emacs-bootstrap --dry-run  print what would be installed/removed, change nothing
emacs-bootstrap --upgrade  sync, then upgrade everything installed
```

1. Reads both lists. If either is unreadable, it exits 1 having changed
   nothing.
2. Installs listed packages that are missing, refreshing the archive index
   first. A stale cached index can name a version the archive no longer
   serves, and that download 404s. These installs don't rewrite the lists.
3. Removes installed packages that are neither listed nor needed by something
   listed. It never removes anything when the lists are empty.
4. Loads `init.el` exactly as a real start would, which proves it loads, and
   reports any skipped config blocks.
5. Exits nonzero if any install failed. When there's nothing to do it makes
   no network calls.

The GNU ELPA signing key needs no setup. On the first refresh, Emacs imports
its bundled keyring into the fresh `elpa/gnupg` automatically, batch mode
included.

Environment: `EMACS` (default `emacs`) and `EMACS_DIR` (default `~/.emacs.d`).

### `./init` (`install_emacs`)

- Links `~/.emacs` to the signpost `emacs/dot-emacs.el`. Anything else already
  at `~/.emacs` (a hand-written file, or the old layout's link to `.emacs`) is
  moved into `~/.dotfiles_backup/<stamp>/` first, because it would load instead
  of your config. A link that already points at the signpost is left alone.
- **Legacy layout** (`~/.emacs.d` is a symlink to this repo's `.emacs.d`): it
  replaces the link with a real directory and copies over local state
  (history, recentf, smex, tramp, `transient/`, ...). It doesn't copy `elpa/`,
  `auto-save-list/`, `eln-cache/`, `*~` or `.#*`. The whole old directory is
  moved to `~/.emacs.d.legacy-<stamp>` and nothing is deleted; remove it
  yourself once things work.
- If `~/.emacs.d` is a symlink pointing anywhere else, it warns and leaves it
  alone.
- Links `early-init.el`, `init.el` and `lisp` into `~/.emacs.d`.
- On a known host (the `$HOSTNAME` table at the top of `init`), it links
  `packages-local.el` to `host/<host>/emacs/packages-local.el`. If a plain
  local list already exists there, it's moved into the repo first (commit
  it). On an unknown host the local list stays a plain, untracked file.
- **Syncs** by running `emacs-bootstrap`, with the full log at
  `~/.dotfiles_backup/<stamp>/emacs-bootstrap.log`. A sync failure (offline,
  a merge conflict) prints a warning, and `init` still finishes. The sync is
  skipped with `EMACS_BOOTSTRAP=0`, when running as root, or when Emacs is
  missing or older than 30.

Running `./init` again is safe, and that's the expected thing to do after
every pull.

## Migrating a host that has the old layout

Before this change, `~/.emacs.d` was a symlink into the repo, and `elpa/` was
tracked in git.

```sh
# stop any running Emacs daemon first: its packages are about to move
cd ~/prog/dotfiles
git pull
./init      # real ~/.emacs.d, state carried over, old dir kept as .legacy-*, packages synced
```

Between the pull and `./init`, a freshly started Emacs on that host has
neither a config nor packages.

## When a package list has a merge conflict

Two machines that each installed something before pulling can both touch
`emacs/packages.el`. Because the list is sorted with one name per line, git
usually merges it on its own. When it can't:

1. Edit the file: keep **both** sides' names, delete the `<<<<<<<`,
   `=======` and `>>>>>>>` lines, and keep the list sorted (an unsorted list
   still works, but `tests/emacs-test` flags it).
2. `tests/emacs-test` confirms the file is canonical again.
3. Commit, then run `./init` (or `emacs-bootstrap`) and restart Emacs.

Until it's fixed, nothing is lost. Emacs warns at startup and doesn't touch
the lists, `emacs-bootstrap` exits without changing anything, and `./init`
prints a warning but finishes.

## Adding a new machine

`./init` picks the host name from the `$HOSTNAME` table at the top of
`init` (cosmo, station, handslap, ahands, handsair). A machine that isn't in
the table still gets the full shared list, but its local list is a plain,
untracked file. To track it:

1. Add a line to that table, e.g.
   `[[ "$HOSTNAME" =~ "newbox" ]] && host=newbox`, and commit.
2. Run `./init`. If a local list already exists, it's moved to
   `host/newbox/emacs/packages-local.el`. Commit that file.

## Tests

| Script | Needs | Checks |
|---|---|---|
| `tests/emacs-test` | git only, runs anywhere | nothing tracked under `.emacs.d/`; `emacs/` holds only `.el` files plus this README; `packages.el` and every `host/*/emacs/packages-local.el` are canonical (sorted, no duplicates, no conflict markers); `packages-local.el` tracked only under `host/*/emacs/`; no Customize-style package list and no `use-package-always-ensure`; `./init` syncs and links the host list; the `~/.emacs` signpost is tracked, loads `init.el`, and is linked by `./init`; no http archives |
| `tests/emacs-smoke` | Emacs 30+ and network | works on a *copy* of `emacs/` in a temp dir: sync from nothing; keyring imported; rerun does nothing; about 20 file types open in the right mode; `C-x a` per mode; install, make-local and delete each update the right list (and the shared list comes back byte for byte); a simulated pull installs and removes to match; conflict markers make sync fail and change nothing; an orphaned block is skipped, warned about, kept on `n` (no hang), and trimmed exactly on `y`; a **real, non-batch startup** (an Emacs daemon) through `~/.emacs` loads the config with no warnings; the real checkout is untouched |

```sh
tests/emacs-test
tests/emacs-smoke                        # ~1 min, full download
KEEP_DIR=/tmp/emacs-smoke tests/emacs-smoke   # reuse downloads for fast reruns
```

Nothing runs these automatically.

## Gotchas

- **`emacs` in an interactive shell is `emacsclient`** (alias in `.bashrc`).
  Scripts don't see aliases, so `emacs-bootstrap` gets the real binary. If you
  type `emacs --batch ...` by hand, use `command emacs`.
- **Installing from Lisp also records it.** `package-install` and
  `package-delete` update the lists the same way the UI does. Passing
  `package-install`'s DONT-SELECT argument installs without recording.
- **No version pinning.** Every machine gets whatever MELPA serves on the day
  it installs or upgrades, so machines can drift. If that ever causes trouble,
  switching to elpaca or straight.el with a lockfile is the next step.
- **`lua-mode` is built into Emacs 31**, so package.el counts it as installed
  and uses the built-in version rather than downloading MELPA's.
- `.php`/`.inc` map to `hack-mode`, which isn't installed, so those files open
  in `fundamental-mode`. This is the existing behavior, kept on purpose.
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
all travelling between machines through `git pull`. The package list sat
inside `custom-set-variables` in `.emacs` and had drifted: it named 10
packages that were never installed.

Now `~/.emacs.d` is local, and the list is the one file package.el was
always maintaining, just saved somewhere git can see it and kept separate
from your config.

The lists were seeded with 64 packages. While porting, the old list (82
entries) lost 20 and gained 2:

- **Removed, gone from the archives or never installed:** highline, lineno,
  markdown-mode+, puppetfile-mode, company-box, company-c-headers,
  company-cmake, flymake-shellcheck, helm-git
- **Removed, built in now:** eglot, eldoc
- **Removed, dead upstream or superseded:** lsp-python-ms, racer,
  flow-minor-mode, lsp-pyre, flycheck-pyre, company-go, go-eldoc
- **Removed, pure dependencies:** epc, json-rpc
- **Added explicitly:** flycheck (it was configured, but only arrived as a
  dependency) and markdown-mode
