# yobuild

Yobuild is a trivial portable metabuild system for open source packages
on both Linux and Mac OS X.
It's handy for application developers who need a way to build dependencies they can ship with their app.
It generates tarballs for each package.  On Ubuntu, it can also generate .deb packages.

## installing

To install yobuild from source, do 'sudo make install'.  This is very quick, it doesn't build any packages.

Then to read the documentation, do 'man yb_buildone'.

You can uninstall it with 'sudo make uninstall'.

## building

For a list of supported packages, do 'yb_list'.

To build a single package (e.g. xz), do 'yb_buildone xz'.

To build an entire suite of packages, run yb_buildone in a loop, earliest dependencies first;
see /usr/share/doc/yobuild/yobuild-osx-example.sh for an example.

To build a .deb for a package (e.g. xz), run 'yb_makedebian xz', then 'cd yobuilt-xz; debuild -b';
see /usr/share/doc/yobuild/yobuild-ubu12-example.sh for an example.

## recipes

Yobuild recipes are standalone scripts which live in /usr/share/yobuild/recipes.

A typical recipe, /usr/share/yobuild/recipes/xz.recipe, looks like this:

```
yb_default xz http://tukaani.org/xz/xz-5.0.4.tar.gz d67405798dad645965fe51cf4e40c23d1201fb234378d3c44f5a3787142b83b6
```

where the long hex string is the sha256sum of the source tarball.


## extending

To tweak an existing recipe (say, the one for xz), do 'cd recipes/xz', then edit xz.recipe

To add a patch to a recipe, drop it in the folder recipes/xz/patches

To try out your new recipe, just run it, e.g. ./xz.recipe

To submit your recipe for inclusion in upstream yobuild, do a pull request on github,
or email dank@kegel.com.

If you have a Mac, please test your recipe first with

```
YB_WIDTH=universal recipes/FOO/FOO.recipe
```

If that fails to build, try adding the --lipo option to yb_default.


## bugs

Submit bug reports via the github issue tracker, or by email to dank@kegel.com.
