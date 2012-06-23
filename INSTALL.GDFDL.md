GDFDL Installation examples
===========================

You have basically 3 options to install:


### 1. Install via Web Installer
Easiest way to install is to use the web installer as you would only need to
copy & paste one single command line:

````Shell
CURLOPT_SSL_VERIFYPEER=true curl -sL -o .i -w "URL=\"%{url_effective}\" \
 bash .i \$@" <URL-to-raw-install-wrapper-script> | bash [-s BRANCH]
````

This is the favorit method for end users.
The `<URL-to-raw-install-wrapper-script>` is the raw download URL of
`gdfdl-scripts/gdfdl-install-wrapper`,
e.g. https://raw.github.com/user/project/branch/gdfdl-scripts/gdfdl-install-wrapper.
As this makes the one-liner a bit too long you might want to setup an
http redirect from one of your (sub)domains to this. It is working out of the box.

Giving a branch name at the very end is optional so that you can use the same
http redirect URL (=one shared install-wrapper) even when installing from
different branches.

Using `CURLOPT_SSL_VERIFYPEER=true` at the beginning is optional and only
useful if you want to make sure cURL is always verifing the SSL certificate
for security reasons. GDFDL does this anyway when loading the other parts but
to have a fully-correct chain of trust, adding this option here can be
considered so that we don't rely on the host's local default setting which
*might* be different.

However, do **NOT** change the option `%{url_effective}` as it is actually not an
GDFDL option but used internally by cURL to provide us the loading URL so that
we can determine the correct web loading points for the other files.

Currently the Web Installer only supports GitHub and Bitbucket as we need to
know the URL structure of the provider to load our installation files.
Feel free to extend the wrapper script for additional hosting providers.


### 2. Install from local Git clone (for humans)
You may use the local installer from Continuous Integration scripts
After you have cloned the repository your favorite way, use this command to install:

`./gdfdl-ci/01-install/00-run.sh <DIRECTORY>`

This will install the build environment to <DIRECTORY>. Note that giving a
destination directory is mandatory here, otherwise you would end in a special
debugging installation which is normally not what you want to see.


### 3. Install from local Git within CI (for machines)
If you would like to run the automated tests included in the `gdfdl-ci`
directory in your Continuous Integration system (e.g. Jenkins), you might prefer using the local
installer from point 2 as you can use normal SCM management functions. So after
cloning your repo, just use the command from point 2 leaving out the directory
part. GDFDL will be installed in a subdirectory `./.ci` where you can do all
the normal GDFDL stuff then.

This is only a short introduction to the CI usage of GDFDL. See `gdfdl-ci/README.md` for more details.
