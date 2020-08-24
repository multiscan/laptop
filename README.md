# Mac Laptop installation

A part from the apps that have to be installed manually listed below, everything should be installed and configured via the `go.sh` script in this directory. The script is idempotent and is heavily based on the [laptop script][1] by Thoughbot. Most of the things are done via [brew][3]

`go.sh` should be executed only once. Then `local.sh` should be enough as all modifications goes therein.

Most of the `dotfiles` are from [thoughtbot rcm][2] or slightly modified. 

## Done manually
 * Created three extra volumes (this zfs-like volume system is cool):
   1. `/Volumes/Scratch`: for volatile data that I will not backup (e.g. docker images, temp files);
   2. `/Volumes/Priv`: my private stuff that I will backup frequently;
   3. `/Volumes/Archive`: old stuff mostly read-only. No need to backup frequently.
   For the moment volumes are not port of the mandatory Druva inSync backup. Hope it stays like this.
 * Enable root user: `Directory Utility -> Unlock -> Edit menu(Enable Root User)`
 * [Docker CE Desktop][6] this also exists  as a `cask` but I was not sure which one to take...
 * Executed this `go.sh` script (of course!)
 * Enable mounting into `/keybase` for Keybase (see below);
 * Installed Acrobat Reader as cask is not available

 
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
Working solution found [here][9] is to run the following command and reboot
```
 grep -q keybase /etc/synthetic.conf || echo keybase >> /etc/synthetic.conf
```

The only issue is that it have to be issued by root: admin user with `sudo` is not enough. 

#### Alternative (discarded) solution

I keep this because it might be useful in other situations

I had some issues in making Keybase KBFS work. After few attempts (not clear why) it could mount into `/Volumes/Keybase` but not create the magic `/keybase` mount. It is not clear if the key was to reboot or something else like starting keybase while keeping security pane in system preferences unlocked. 

The root filesystem of OsX 10.15 is readonly. Therefore keybase cannot write the `/keybase` directory. 
There is a [way to make it writable][8] though: 

  1. Reboot into Recovery Mode holding down Command+R until the Apple logo appears on your screen;
  2. `csrutil disable`;
  3. Restart your Mac;
  4. Happily write on your root filesystem: in this particular case a symlink from `/keybase` to `/Volumes/Keybase` or just `/keybase` as a directory);
  5. repeat with `csrutil enable`.

#### TM disk keeps running all the time
This is due to the fact that spotlight is indexing it for some insane apple idea. Unfortunatelly this seams to be [impossible to turn off][14]:

```
% sudo mdutil -i off /Volumes/wdeTM 
Password:
/System/Volumes/Data/Volumes/wdeTM:
2020-03-25 09:26:23.167 mdutil[77741:7287780] mdutil disabling Spotlight: /System/Volumes/Data/Volumes/wdeTM -> kMDConfigSearchLevelFSSearchOnly
	Indexing enabled. (Indexing level may not be changed on volumes which have a Time Machine backup)
playground % sudo mdutil -s /Volumes/wdeTM 
/System/Volumes/Data/Volumes/wdeTM:
	Indexing enabled. 
```

Thank and f**k you Apple!


#### Launchctl crush course

From an [answer on stack exchange][chiggsy]:

`launchctl` has changed for the better in 10.11.4

Type the command without arguments to get the help. You'll see new domains to search and new commands.

```
launchctl print system     #prints the system domain (root)
launchctl print system/com.system.service     #prints details about a service in roots domain.
```

For your processes: if it's not in the system domain it's probably in your user:

```
launchctl print user/(your uid)/
launchctl print user/(your uid)/com.user.agent
```

However, since you'll be logged into the gui:

```
launchctl print gui/(your uid)/
launchctl print gui/(your uid)/org.adobe.NSAmonitor # or whatever they call what you are looking for
```

 - Gui domain for things that have a UI/Agents
 - User domain for daemons for you.
 - System domain for system daemons.

There are a couple more but I find user and gui are pretty good.

The trick with later versions of OSX is to check the man page and then run the tool help. If it's running, you can find it with launchctl.

```
man launchctl
launchctl -h
```


 

## TODO:
 - [ ] Get rid of rcm before running 'local.sh'
 - [ ] Docker Community Edition as cask instead of manually!
 - [X] Find an alternative to GitX. Looks like Fork is a very good, even better alternative.
 - [ ] Check if it is possible to make `sudo` equivalent to user root. 

## LINKS
 - [Thoughtbot laptop][1]
 - [Thoughtbot rcm][2]
 - [Homebrew][3]
 - [Brew formula list][4]
 - [Brew cask list][5]
 - [Docker CE Desktop][6]
 - [asdf][10] plugins: [ruby][11], [python][12], [nodejs][13]
 - [Improve Time Machine performance on network drives][15]
 - [restic][16] and restic [cryptography analysis][17]
 - [kickstart][18] command for managing remote management preferences

[1]: https://github.com/thoughtbot/laptop
[2]: https://github.com/thoughtbot/rcm
[3]: https://brew.sh/
[4]: https://formulae.brew.sh/formula/
[5]: https://formulae.brew.sh/cask/
[6]: https://hub.docker.com/editions/community/docker-ce-desktop-mac
[7]: https://forums.developer.apple.com/thread/119790
[8]: https://lifehacker.com/how-to-fix-os-x-el-capitans-annoyances-1733836821
[9]: https://github.com/keybase/client/issues/14689
[10]: https://github.com/asdf-vm/asdf
[11]: https://github.com/asdf-vm/asdf-ruby
[12]: https://github.com/danhper/asdf-python
[13]: https://github.com/asdf-vm/asdf-nodejs
[14]: https://mjtsai.com/blog/2017/10/19/you-cant-turn-off-spotlight-on-your-time-machine-backup/
[15]: https://edoardofederici.com/improve-time-machine-performance/
[16]: https://restic.readthedocs.io/en/latest/index.html
[17]: https://blog.filippo.io/restic-cryptography/
[18]: https://support.apple.com/en-us/HT201710
[chiggsy]: https://apple.stackexchange.com/questions/236577/how-to-disable-adobe-core-sync-app-on-os-x-from-being-launched-automatically/237585#answer-237399

