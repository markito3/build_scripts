#!/bin/tcsh
setenv TODAYS_DATE `date +%F`
setenv BUILD_DIR /scratch/gluex/halld_builds/$TODAYS_DATE
setenv BUILD_SCRIPTS /group/halld/Software/scripts/build_scripts
setenv BMS_OSNAME `$BUILD_SCRIPTS/osrelease.pl`
setenv RUN_DIR /scratch/gluex/b1pi/$TODAYS_DATE/$BMS_OSNAME
# xerces-c
setenv XERCESCROOT /group/halld/Software/ExternalPackages/xerces-c-src_2_7_0.$BMS_OSNAME
# Jana
setenv JANA_HOME /group/12gev_phys/builds/jana_0.6.2/$BMS_OSNAME
setenv JANA_CALIB_URL file:///group/halld/calib
# ROOT
setenv ROOTSYS `$BUILD_SCRIPTS/cue_root.pl`
# CERNLIB
setenv CERN_CUE `$BUILD_SCRIPTS/cue_cernlib.pl`
setenv CERN /apps/cernlib/$CERN_CUE
setenv CERN_LEVEL 2005
# Hall D
setenv HALLD_HOME $BUILD_DIR/sim-recon
setenv HALLD_MY $HALLD_HOME
# HDDS
setenv HDDS_HOME $BUILD_DIR/hdds
# finish the rest of the environment
source $BUILD_SCRIPTS/gluex_env.csh
# do the build
mkdir -p $RUN_DIR
cd $RUN_DIR
$BUILD_SCRIPTS/b1pi.csh
cp $BUILD_SCRIPTS/../b1pi_macros/* .
root -q -b momentum.C
root -q -b theta.C
root -q -b mass_X.C
setenv PLOTDIR /group/halld/www/halldweb1/html/b1pi/$TODAYS_DATE/$BMS_OSNAME
mkdir -p $PLOTDIR
cp -v *.pdf *.png $PLOTDIR
exit