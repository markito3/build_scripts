#!/bin/tcsh
#
# process arguments
set test_mode = 0
if ($#argv > 0) then
    switch ($argv[1])
	case -t:
	    echo $0 running in test mode
	    set test_mode = 1
	    shift
	    breaksw
	default:
	    echo "invalid argument"
	    exit
    endsw
endif
#
setenv TODAYS_DATE `date +%F`
if ($test_mode) then
    setenv TARGET_DIR /scratch/$USER/nightly/$TODAYS_DATE
else
    setenv TARGET_DIR /group/halld/Software/builds/nightly/$TODAYS_DATE
endif
# go to the target directory
mkdir -p $TARGET_DIR
cd $TARGET_DIR
# build scripts
setenv BUILD_SCRIPTS $TARGET_DIR/build_scripts
svn co file:///group/halld/Repositories/svnroot/trunk/scripts/build_scripts
# ccdb
mkdir -p `$BUILD_SCRIPTS/osrelease.pl`
setenv CCDB_HOME $TARGET_DIR/`$BUILD_SCRIPTS/osrelease.pl`/ccdb
# hdds
setenv HDDS_HOME $TARGET_DIR/hdds
# Hall D
setenv HALLD_HOME $TARGET_DIR/sim-recon
setenv HALLD_MY $HALLD_HOME
# finish the rest of the environment
source $BUILD_SCRIPTS/gluex_env_jlab.csh
# make ccdb
pushd $BMS_OSNAME
make -f $BUILD_SCRIPTS/Makefile_ccdb
popd
# make hdds
make -f $BUILD_SCRIPTS/Makefile_hdds make_hdds
make -f $BUILD_SCRIPTS/Makefile_hdds make_hdds DEBUG=1
# make sim-recon
make -f $BUILD_SCRIPTS/Makefile_sim-recon make_halld
make -f $BUILD_SCRIPTS/Makefile_sim-recon make_halld DEBUG=1
# Create environment setup script based on what was just used for building
# (added 2010-09-03 DL)
cd $HALLD_HOME
unsetenv HALLD_MY
/group/halld/Software/scripts/mk_setenv.csh
#
exit
