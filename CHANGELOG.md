# 2.1.6

* Confirm (using Fog) that the current instance flavor has instance storage

# 2.1.5

* Disable /mnt mount (instead of just unmounting it) and enable the new mounts

# 2.1.4

* Populate ephemeral_mounts attribute even if /mnt/dev is already mounted

# 2.1.3

* Use /proc/mounts (rather than node attributes) to see if we need to run
* Fix method reference error in vagrant support

# 2.1.2

* s/ephemeral1/ephemeral0/ in library this time

# 2.1.1

* Look for ephemeral0 in ec2 attributes

# 2.1.0

* Fixed error making it impossible to converge twice
* Move format-mount to a resource
* Library-ify a bunch of small functions

# 2.0.2

* Add some real content to the README
* Handle NPE by only printing mounts if there are any

# 2.0.1

* Do umount during precompile phase

# 2.0.0

* Add vagrant support

# 1.0.1

* Initial release
