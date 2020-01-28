# Mac Laptop installation

A part from the apps that have to be installed manually listed below, everything should be installed and configured via the `go.sh` script in this directory. The script is idempotent and makes eavy use of the [laptop script][1] by Thoughbot. Most of the things are done via [brew][3]

`go.sh` should be executed only once. Then `local.sh` should be enough as all modifications goes therein.

Most of the `dotfiles` are from [thoughtbot rcm][2] or slightly modified. 

## Done manually
 * [Docker CE Desktop][6] this also exists  as a `cask` but I was not sure which one to take...


#### Firefox
All the plugin are automatically installed as soon as the Firefox Sync service is activated. 

#### Docker
I have moved the location of the image for docker into `/Volumes/Scratch/Docker`. Hope this will help keeping the insync backup lightweight.

#### GitX 
Is not working because it was never compiled for 64bit only systems. **Need to find an alternative!**


## TODO:
 - [ ] Get rid of rcm before running 'local.sh'
 - [ ] Docker Community Edition as cask instead of manually!
 - [ ] Find an alternative to GitX

## LINKS
 - [Thoughtbot laptop][1]
 - [Thoughtbot rcm][2]
 - [Homebrew][3]
 - [Brew formula list][4]
 - [Brew cask list][5]
 - [Docker CE Desktop][6]

[1]: https://github.com/thoughtbot/laptop
[2]: https://github.com/thoughtbot/rcm
[2]: https://brew.sh/
[4]: https://formulae.brew.sh/formula/
[5]: https://formulae.brew.sh/cask/
[6]: https://hub.docker.com/editions/community/docker-ce-desktop-mac