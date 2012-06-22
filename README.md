GDFDL
=====

A Git development framework to ease creation and deployment of ISO-based
appliances with Debian[^1]'s build automator [live-build][live-build].
It offers easy installation and management of a consistent and reliable
build environment:

* Easy single-line installation:  
  just copy & paste a one-liner to get started, loads and verifies installer
  via secure HTTPS
* End-user compatible:  
  Let your customers easily build a fresh copy of your software out of the same
  source you use
* Works with every Linux distribution:  
  only needs sudo, curl, debootstrap and chroot installed
  (Debian/Ubuntu for easier availability of debootstrap preferred though)
* Avoids clutter in your local Linux installation:  
  Keeps everything in a single folder, clean-up and uninstall with a single
  command
* Ready for enterprise:  
  Continuous Integration Systems support (e.g. Jenkins)
* Single configuration file:  
  One main configuration file for all settings and environment variables
* Easy Git development handling:
  - Tested support for GitHub & Bitbucket
  - Easy branch & fork support: Automatically works from every Git's home
  - Update your Git right out of the build environment: Just enter your
    credentials to the local conf file
  - Avoids upload of local configuration files and protects private information
    like your Git credentials
  - Developed with smooth upgrade/merge support for your own copy from this
    master project (create your own files instead of changing those coming
	from GDFDL)
* Highly customizable:  
  Let's you define naming and branding directly in the config file
* Automatic handling of build names:  
  Stamps your ISO with an obvious build number
* Auto-update function:  
  Automatically keeps local build environment up-to-date, excludes local config
  file automatically
* Checksum support:  
  automatically creates MD5, SHA1 and SHA256 checksum files for your ISO
* GnuPG support:  
  Optionally signs checksum files if GPG data is present
* ISO versioning control:  
  automatically symlinks to latest ISO file and deletes obsolete versions after
  defined days
* IPv6 ready
* Support for Debian Live 2.0 and 3.0 based distributions:  
  currently Squeeze, Wheezy and Precise

For more details about features, installation and handling instructions
visit [the homepage][home] or use command-line option `help`.


Who are you?
------------
I am Julian Pawlowski aka [@Loredo][author_twitter].



[^1]: Debian is a trademark of Software in the Public Interest, Inc.

[home]:http://gdfdl.profhost.eu/
[wiki]:http://gdfdl-wiki.profhost.eu/
[author_twitter]:http://twitter.com/Loredo
[live-build]:http://live.debian.net/devel/live-build/
