# Mac Laptop installation

A part from the apps that have to be installed manually listed below, everything should be installed and configured via the `go.sh` script in this directory. The script is idempotent and makes eavy use of the [laptop script](https://github.com/thoughtbot/laptop) by Thoughbot. 



## Done manually
 * [Docker](https://hub.docker.com/editions/community/docker-ce-desktop-mac)

### Firefox
All the plugin are automatically installed as soon as the Firefox Sync service is activated. 

### Docker
I have moved the location of the image for docker into `/Volumes/Scratch/Docker`. Hope this will help keeping the insync backup lightweight.

### GitX 
Is not working because it was never compiled for 64bit only systems. **Need to find an alternative!**

