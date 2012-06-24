# GDFDL
Continuous Integration
======================

Usage with CI systems like Jenkins to be described.


Copy&Paste to Jenkins/Hudson Execute shell field after you have cloned the Git:  
(depending on your needs)  

````Shell
./gdfdl-ci/00-uninstall/00-run.sh
./gdfdl-ci/01-install/00-run.sh
./gdfdl-ci/02-build/00-run.sh
./gdfdl-ci/03-QA/00-run.sh
./gdfdl-ci/04-deploy/00-run.sh
./gdfdl-ci/05-cleanup/00-run.sh
````

Note that it does not necessarily make sense to just run all scripts in series.  
Normally you want to stop after QA and handle deployment and cleanup tasks in
the post-build section in Jenkins.
Also make sure to archive the artifacts (your ISO files) with Jenkins internal
function before running the cleanup script.
