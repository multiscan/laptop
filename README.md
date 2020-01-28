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


## Notes

#### Mail
The directory where Apple Mail stores data (`~/Library/Mail`) cannot be touched. 
I tried to move or rename it but I get a _permission denied_ even as sudo! 
Fuck You Apple!
Luckily, it is excluded from Druva backup so I can use it also for private gmail account. 
The alternative is to switch to Thunderbird. 

#### Keybase
I had some issues in making Keybase KBFS work. After few attempts (not clear why) it could mount into `/Volumes/Keybase` but not create the magic `/keybase` mount. It is not clear if the key was to reboot or something else like starting keybase while keeping security pane in system preferences unlocked. 

The root filesystem of OsX 10.15 is readonly. Therefore keybase cannot write the `/keybase` directory. 
There is a [way to make it writable][8] though: 

  1. Reboot into Recovery Mode holding down Command+R until the Apple logo appears on your screen;
  2. `csrutil disable`;
  3. Restart your Mac;
  4. Happily write on your root filesystem;
  5. repeat with `csrutil enable`.

For the moment I have simply created a symlink but this will require changing all the scripts:

```
ln -s "/Volumes/Keybase ($(whoami))"   $HOME/keybase
```


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
[3]: https://brew.sh/
[4]: https://formulae.brew.sh/formula/
[5]: https://formulae.brew.sh/cask/
[6]: https://hub.docker.com/editions/community/docker-ce-desktop-mac
[7]: https://forums.developer.apple.com/thread/119790)
[8]: https://lifehacker.com/how-to-fix-os-x-el-capitans-annoyances-1733836821