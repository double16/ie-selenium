ie-selenium
===========

Sets up local IE instances for Selenium testing using Vagrant + modern.ie + VirtualBox.

The Vagrant boxes are created and hosted by modern.ie. Unfortunately remote management is disabled so that Vagrant
provisioning cannot be used. There is a post-boot.sh script that will update the Vagrant boxes with Java and Selenium.
Selenium is set up in stand alone mode, not as nodes in a grid, although modifications could be done to these scripts to
make it happen.

Selenium code and configurations have been borrowed from https://github.com/conceptsandtraining/modernie_selenium.

Some configurations based on https://gist.github.com/tvjames/6750255.

The scripts were written on Mac OS X 10.9. They may not work on Linux or cygwin. Send pull requests if you'd like to fix
them.

How To
------

For each box (in this case IE10_Win7):
```
vagrant up IE10_Win7
```

Provisioning won't work so vagrant will fail, but the VM will be created.

After all boxes are created:
```
./post-boot.sh
```
