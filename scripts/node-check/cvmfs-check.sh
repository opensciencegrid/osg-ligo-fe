#
#
# Script for verifying that CVMFS is available in a node
#
#
# Created by Edgar on August 3 2015
#
#############################################
#
#
#!/bin/sh

glidein_config="$1"

# find error reporting helper script
error_gen=`grep '^ERROR_GEN_PATH ' $glidein_config | awk '{print $2}'`
# skip test if entry is stampede
entry_name=`grep "^GLIDEIN_Entry_Name " $glidein_config | awk '{print $2}'`
echo "Entry name: " $entry_name
if [ $entry_name = "HCC_US_IL_BLUE_WATERS_LIGO" ]; then
  echo "CVMFS not checked because entry is Blue waters"
  exit 0
fi
if [ -e "/cvmfs/oasis.opensciencegrid.org/osg-software/osg-wn-client/3.4/current/el6-x86_64/setup.sh" ]; then
  echo "CVMFS found"
  "$error_gen" -ok "cvmfs/oasis" 
  exit 0
fi

"$error_gen" -error "/cvmfs/oasis.opensciencegrid.org/osg-software/osg-wn-client/3.3/current/el6-x86_64/setup.sh" "WN_Resource" "CVMFS oasis not found" "file" "/cvmfs/oasis.opensciencegrid.org/osg-software/osg-wn-client/3.3/current/el6-x86_64/setup-local.sh"
exit 1
