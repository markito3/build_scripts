#!/bin/bash
export BUILD_SCRIPTS=/group/halld/Software/build_scripts
$BUILD_SCRIPTS/customize_version.pl \
    -i /group/halld/www/halldweb/html/dist/version_jlab.xml \
    -o ${USER}_`date +%F`.xml \
    -s `pwd`/sim-recon \
    -m `pwd`/hdgeant4 \
    -a `pwd`/gluex_root_analysis
echo source $BUILD_SCRIPTS/gluex_env_jlab.sh `pwd`/${USER}_`date +%F`.xml \
    > setup_gluex.sh
echo source $BUILD_SCRIPTS/gluex_env_jlab.csh `pwd`/${USER}_`date +%F`.xml \
    > setup_gluex.csh
source $BUILD_SCRIPTS/gluex_env_jlab.sh `pwd`/${USER}_`date +%F`.xml
make -f $BUILD_SCRIPTS/Makefile_sim-recon SIM_RECON_SCONS_OPTIONS="-j4"
make -f $BUILD_SCRIPTS/Makefile_hdgeant4
make -f $BUILD_SCRIPTS/Makefile_gluex_root_analysis
