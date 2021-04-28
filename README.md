# Mac Laptop installation

A part from the apps that have to be installed manually listed below, everything should be installed and configured via the `go.sh` script in this directory. The script is idempotent and is heavily based on the [laptop script][tblaptop] by Thoughbot. Most of the things are done via [brew][brew]

`go.sh` should be executed only once. Then `local.sh` should be enough as all modifications goes therein.

Most of the `dotfiles` are from [thoughtbot rcm][tbrcm] or slightly modified. 

## Done manually
 * Created three extra volumes (this zfs-like volume system is cool):
   1. `/Volumes/Scratch`: for volatile data that I will not backup (e.g. docker images, temp files);
   2. `/Volumes/Priv`: my private stuff that I will backup frequently;
   3. `/Volumes/Archive`: old stuff mostly read-only. No need to backup frequently.
   For the moment volumes are not port of the mandatory Druva inSync backup. Hope it stays like this.
 * Enable root user: `Directory Utility -> Unlock -> Edit menu(Enable Root User)`
 * [Docker CE Desktop][dockerdesktop] this also exists  as a `cask` but I was not sure which one to take...
 * Executed this `go.sh` script (of course!)
 * Enable mounting into `/keybase` for Keybase (see below);
 * Installed Acrobat Reader as cask is not available

 
#### Firefox
All the plugin are automatically installed as soon as the Firefox Sync service is activated. 

#### Docker
I have moved the location of the image for docker into `/Volumes/Scratch/Docker`. Hope this will help keeping the insync backup lightweight.

#### GitX 
Is not working because it was never compiled for 64bit only systems. **Need to find an alternative!**

## Backup
Backup is **very important**. I have 3 levels of backup.
 1. automatic time machine on an external usb drive. I do this at least once per
    day (usually in the evening when I finish working) because the external disk
    is very noisy and that shit goes on forever. 
    I plan to replace this with [carbon copy cloner][ccc] which is faster and
    able to start when the disk is attached and umount it when its done so the
    noise is limited to when the backup is active.
 2. automatic, employer imposed, not configurable network backup based on druva 
    in sync. This only backup the main disk. This is the main reason for using
    different partitions. Since it is extremely slow, I wanted to avoid it to 
    backup scratch stuff like docker images which are the most space consuming
    part of my filesystem.
 3. manually controlled very frequent backup (hourly for most important 
    directories) on external UBS disk (a different one) using [restic][restic] 
    (the best backup system out there) driven by my [personal script][myrestic].
    I plan to duplicate this on my synology network drive but I need first to 
    increase its capacity.

## Notes

#### ZSH
It looks like it is the shell to go for these days. I personally don't see much of an 
advantage over bash but I trust my geekier friends. The main advantage is that history
is now merged between different shells so you don't end up deleting the history of 
one shell when you close another one.
At the moment the configuration is a mess mix between the original thoughtbot,
personal modifications, and ideas from my [colleague][nico_terminal]'s example
that makes heavy use of [Oh My Zsh][omzsh].
For the prompt, I have also tested [starship][starship] but I didn't see much 
improvement over standard zsh. Probably it is more usefull for bash.



#### Mail
The directory where Apple Mail stores data (`~/Library/Mail`) cannot be touched. 
I tried to move or rename it but I get a _permission denied_ even as sudo! 
Fuck You Apple!
Luckily, it is excluded from Druva backup so I can use it also for private gmail account. 
The alternative is to switch to Thunderbird. 

#### Keybase
Working solution found [here][kbfix] is to run the following command and reboot
```
 grep -q keybase /etc/synthetic.conf || echo keybase >> /etc/synthetic.conf
```

The only issue is that it have to be issued by root: admin user with `sudo` is not enough. 

##### Alternative (discarded) solution

I keep this because it might be useful in other situations

I had some issues in making Keybase KBFS work. After few attempts (not clear why) it could mount into `/Volumes/Keybase` but not create the magic `/keybase` mount. It is not clear if the key was to reboot or something else like starting keybase while keeping security pane in system preferences unlocked. 

The root filesystem of OsX 10.15 is readonly. Therefore keybase cannot write the `/keybase` directory. 
There is a [way to make it writable][lh] though: 

  1. Reboot into Recovery Mode holding down Command+R until the Apple logo appears on your screen;
  2. `csrutil disable`;
  3. Restart your Mac;
  4. Happily write on your root filesystem: in this particular case a symlink from `/keybase` to `/Volumes/Keybase` or just `/keybase` as a directory);
  5. repeat with `csrutil enable`.

#### TM disk keeps running all the time
This is due to the fact that spotlight is indexing it for some insane apple idea. Unfortunatelly this seams to be [impossible to turn off][spotlightshit]:

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


## Tricks

For monitoring cpu power throtling: `pmset -g thermlog`. If the `CPU_Speed_Limit` 
goes below 100, then the cpu is throttling. As an alternative, there is a GUI 
from [intel][ipg] but it installs a kernel extension and I am not sure this is 
a good idea although it is provided with `/Applications/Intel\ Power\ Gadget/Uninstaller.pkg`
that is supposed to clean up. 


## TODO:
 - [ ] Get rid of rcm before running 'local.sh'
 - [ ] Docker Community Edition as cask instead of manually!
 - [X] Find an alternative to GitX. Looks like Fork is a very good, even better alternative.
 - [ ] Check if it is possible to make `sudo` equivalent to user root. 
 - [ ] Check if this still works on a blank computer... 

## LINKS
 - [Thoughtbot laptop][tblaptop]
 - [Thoughtbot rcm][tbrcm]
 - [Homebrew][brew]
 - [Brew formula list][brewformulas]
 - [Brew cask list][brewcask]
 - [Docker CE Desktop][dockerdesktop]
 - [asdf][asdf] plugins: [ruby][asdf_rb], [python][asdf_py], [nodejs][asdf_node]
 - [Improve Time Machine performance on network drives][tmperf]
 - [restic][restic] and restic [cryptography analysis][restic_crypto]
 - [kickstart][kickstart] command for managing remote management preferences
 - how my colleague Nicolas (who is much geekier than me) [configures his terminal][nico_terminal]


[tblaptop]: https://github.com/thoughtbot/laptop
[tbrcm]: https://github.com/thoughtbot/rcm
[brew]: https://brew.sh/
[brewformulas]: https://formulae.brew.sh/formula/
[brewcask]: https://formulae.brew.sh/cask/
[dockerdesktop]: https://hub.docker.com/editions/community/docker-ce-desktop-mac
[deleteroot]: https://forums.developer.apple.com/thread/119790
[lh]: https://lifehacker.com/how-to-fix-os-x-el-capitans-annoyances-1733836821
[kbfix]: https://github.com/keybase/client/issues/14689
[asdf]: https://github.com/asdf-vm/asdf
[asdf_ruby]: https://github.com/asdf-vm/asdf-ruby
[asdf_py]: https://github.com/danhper/asdf-python
[asdf_node]: https://github.com/asdf-vm/asdf-nodejs
[spotlightshit]: https://mjtsai.com/blog/2017/10/19/you-cant-turn-off-spotlight-on-your-time-machine-backup/
[tmperf]: https://edoardofederici.com/improve-time-machine-performance/
[restic]: https://restic.readthedocs.io/en/latest/index.html
[restic_crypto]: https://blog.filippo.io/restic-cryptography/
[kickstart]: https://support.apple.com/en-us/HT201710
[chiggsy]: https://apple.stackexchange.com/questions/236577/how-to-disable-adobe-core-sync-app-on-os-x-from-being-launched-automatically/237585#answer-237399
[ipg]: https://software.intel.com/content/www/us/en/develop/articles/intel-power-gadget.html
[starship]: https://starship.rs/
[nico_terminal]: https://github.com/ponsfrilus/my-terminal
[omzsh]: https://ohmyz.sh/
[myrestic]: https://github.com/multiscan/mac_restic_backup
[ccc]: https://bombich.com/
