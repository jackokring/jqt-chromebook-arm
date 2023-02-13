# jqt build on Chromebook for Crostini
The source on `2023-02-13` from jsoftware (available on github GPL).

## What's in it?
Includes `jconsole` and a library fetch with various `.git` files removed. I've had to archive the source to save space. The git submodules of the library are in the archive I've google drived. This is a static build on the date which works on `arm64` Chromebook board `kappa`. It needed some massaging to not stall on the low memory while building `jconsole` and the main library, and a lot of `Qt5` dev packages.

You may have to make yourself a `profile.ijs` file to set your configuration and alter file paths for the `addons` directory. I may do later builds if any major updates occur. I'd have to make space, unpack, build repack and yes, that would be annoying for free.
