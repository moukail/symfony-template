### Vagrant
```
vagrant up --provision
vagrant up
vagrant reload
vagrant ssh
```

#### Virtualbox Guest Additions

```
vagrant plugin install vagrant-vbguest
vagrant vbguest --do install --no-cleanup
vagrant vbguest --status
```

```
Vagrant was unable to mount VirtualBox shared folders. This is usually
because the filesystem "vboxsf" is not available. This filesystem is
made available via the VirtualBox Guest Additions and kernel module.
Please verify that these guest additions are properly installed in the
guest. This is not a bug in Vagrant and is usually caused by a faulty
Vagrant box. For context, the command attempted was:

mount -t vboxsf -o uid=1000,gid=1000,_netdev var_www_ /var/www

The error output from the command was:

/sbin/mount.vboxsf: mounting failed with the error: No such device
```