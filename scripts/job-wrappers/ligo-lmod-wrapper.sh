#!/bin/bash
if [ -e /cvmfs/oasis.opensciencegrid.org/osg/modules/lmod/current/init/bash ]
then
    source /cvmfs/oasis.opensciencegrid.org/osg/modules/lmod/current/init/bash
else
    echo "File /cvmfs/oasis.opensciencegrid.org/osg/modules/lmod/current/init/bash not found" 1>&2
fi


# Script ported from the OSG VO frontend                                                                                                                     
#                                                                                                                                                            
# https://github.com/opensciencegrid/osg-flock/blob/master/job-wrappers/user-job-wrapper.sh                                                                  
#                                                                                                                                                            
#                                                                                                                                                            
#
##############################################################################
#
#  Stash cache 
#
######################################################
StashCache=(`grep ^WantsStashCache $_CONDOR_JOB_AD`)
PosixStashCache=(`grep ^WantsPosixStashCache $_CONDOR_JOB_AD`)
 
function setup_stashcp {
  module load xrootd
  module load stashcp
 
  # Determine XRootD plugin directory.
  # in lieu of a MODULE_<name>_BASE from lmod, this will do:
  export MODULE_XROOTD_BASE=$(which xrdcp | sed -e 's,/bin/.*,,')
  export XRD_PLUGINCONFDIR=$MODULE_XROOTD_BASE/etc/xrootd/client.plugins.d
 
}
 
# Check for PosixStashCache first
if [[ ${PosixStashCache[2]} == 'true' || "${PosixStashcache[2]}" == '1' ]]; then
  setup_stashcp
 
  # Add the LD_PRELOAD hook
  export LD_PRELOAD=$MODULE_XROOTD_BASE/lib64/libXrdPosixPreload.so:$LD_PRELOAD
 
  # Set proxy for virtual mount point
  # Format: cache.domain.edu/local_mount_point=/storage_path
  # E.g.: export XROOTD_VMP=data.ci-connect.net:/stash=/
  # Currently this points _ONLY_ to the OSG Connect source server
  export XROOTD_VMP=$(stashcp --closest | cut -d'/' -f3):/stash=/
 
elif [[ "${StashCache[2]}" == 'true' || "${StashCache[2]}" == '1' ]]; then
  setup_stashcp
 
fi


