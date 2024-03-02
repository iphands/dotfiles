#!/bin/bash
renice -20 `pgrep -w qemu`
renice -10 `pgrep -w X` `pgrep -w compton` `pgrep -w fluxbox`
renice -5  `pgrep -w chrome` `pgrep -w nacl` `pgrep -w pulseaudio` `pgrep -w term`
renice -5  `pgrep -w emacs`

renice 1  `pgrep -w slack`
renice 19 `pgrep -w conky`

