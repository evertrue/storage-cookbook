# storage CHANGELOG

## v2.2.4 (2015-04-07)

* Create an rspec test for disable_mount("/mnt")
* Add a default action: run
* Use rspec3 format in ServerSpec tests.
* Disable mount[/mnt] if there are no ephemeral devices
* Remove usage of encrypted data bag secret
* Remove unused attributes for AWS credentials data bag

## v2.2.3 (2015-03-31)

* Use "greater than" version constraint for et_fog cookbook
* Use blank credentials for connecting to AWS

## v2.2.2 (2015-01-21)

* Fix copypasta in `EverTools::Storage.fog` method re: memoizing

## v2.2.1 (2014-12-11)

* Parameterize credentials data bag location (Fixes #3)

## v2.2.0 (2014-12-08)

* Add testing on Ubuntu 14.04
* Switch to open source license
* Update for Serverspec v2
* Clean up config & other misc. files

## v2.1.8 (2014-09-08)

* Fix the way we deal with a lack of anything to mount and don't blow up when not on ec2
* Test local vagrant storage provisioning (so that wrapper cookbooks stop choking on our crappy code)
* Bump the AMI to a newer version

## v2.1.7 (2014-09-08)

* Update to et_fog v1.1.1 to avoid issues with `apt-get update` & installing `build-essential` at compile time

## v2.1.6 (2014-08-05)

* Confirm (using Fog) that the current instance flavor has instance storage

## v2.1.5 (2014-07-30)

* Disable /mnt mount (instead of just unmounting it) and enable the new mounts

## v2.1.4 (2014-07-28)

* Populate ephemeral_mounts attribute even if /mnt/dev is already mounted

## v2.1.3 (2014-07-17)

* Use /proc/mounts (rather than node attributes) to see if we need to run
* Fix method reference error in vagrant support

## v2.1.2 (2014-07-01)

* s/ephemeral1/ephemeral0/ in library this time

## v2.1.1 (2014-06-30)

* Look for ephemeral0 in ec2 attributes

## v2.1.0 (2014-06-26)

* Fixed error making it impossible to converge twice
* Move format-mount to a resource
* Library-ify a bunch of small functions

## v2.0.2 (2014-06-26)

* Add some real content to the README
* Handle NPE by only printing mounts if there are any

## v2.0.1 (2014-06-25)

* Do umount during precompile phase

## v2.0.0 (2014-05-06)

* Add vagrant support

## v1.0.1 (2014-05-05)

* Initial release
