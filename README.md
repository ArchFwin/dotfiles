Readme
========

This is a collection of various dotfiles and scripts from my Arch Linux system. The files are organised in a logical way.

Chromium-libpdf
========
This folder contains all the scripts and text files I use to maintain the "chromium-libpdf" AUR package.

The update script downloads the latest versions of google-chrome-dev as rpms, and computes their SHA512 sums. It also checks that the license hasn't changed.

The check script builds an install packag and a source package. The contents of the install package are listed, and then the "namcap" utility is used to verify the PKGBUILD and installable package.

The cleanup script removes the downloaded rpms, the source package and the install package.

None of the scripts take any arguments or provide any help, they just run and produce what is hopefully the desired output.

Dwm
========

Warning: dwm.desktop starts a file at /home/andrew/dwm.sh instead of /usr/bin/dwm. This means dwm.desktop needs to be modified before use, and dwm.sh will also probably have to be modified before use.

The dwm.sh script is used to allow programs to autostart, configuration to be done (like feh setting the background) and dwm to actually start.

The patches are all available to download from the urls in the source array of the PKGBUILD (most come directly from the dwm.suckless.org website, but the Pango patch is from Unia), but have been modified to ensure that they will all work (provided they are applied in the same order as the PKGBUILD does them in). Some patch segments have been moved to different patches, and others have been modified.

The update script simply updates the checksums and then builds, installs and removes the install package.

The config.h file will cause issues on an unpatched version of dwm. (It adds some colour options for floating windows, and also some unicode symbols to indicate tiling/floating/monocle layouts). It also adds some extra functions (volume keys modify volume, shutdown and reboot shortcuts) that may not function properly (if your volume keys have different keysyms, or you aren't using systemd).  The termcmd and shcmd have been modified (to use sakura as a terminal and zsh as a shell respectively).

Config
========
This contains a selection of text based configuration files, as well as a list of all the installed packages on my Arch system. The files are all fairly self-explanatory as to their purpose.

Scripts
========
This contains a small selection of scripts I use that don't fit into one of the other categories.

Imdb-thumbnailer
========
This is much like the chromium-libpdf folder, but with less scripts.

To-Do
========
Add power management back into dwm.sh.
Locate and add more config files.
Create a dependency file.
