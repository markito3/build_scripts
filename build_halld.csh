#!/bin/tcsh
# go to the target directory
setenv TODAYS_DATE `date +%F`
set nodename=`uname -n`
if ( X$nodename =~ Xi*farm[0-9]* ) then
    module load gcc_4.9.2
endif
setenv TARGET_DIR /u/scratch/$USER/nightly/$TODAYS_DATE/`/group/halld/Software/build_scripts/osrelease.pl`
setenv BUILD_SCRIPTS $TARGET_DIR/build_scripts
mkdir -p $TARGET_DIR
# get build scripts
cd /group/halld/Repositories/build_scripts
git archive --prefix build_scripts/ master | tar xv -C $TARGET_DIR
cd $TARGET_DIR
cp -v /group/halld/www/halldweb/html/dist/version.xml .
setenv NIGHTLY_DIR $TARGET_DIR
source $BUILD_SCRIPTS/gluex_env_nightly.csh $TODAYS_DATE
# make hdds
make -f $BUILD_SCRIPTS/Makefile_hdds
# make sim-recon
make -f $BUILD_SCRIPTS/Makefile_sim-recon SIM_RECON_SCONS_OPTIONS="SHOWBUILD=1"
# exit
exit
