#!/bin/bash
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

if [ -e "/cvmfs/oasis.opensciencegrid.org/." ]; then
  echo "CVMFS found"
  "$error_gen" -ok "cvmfs/oasis" 
  exit 0
fi

"$error_gen" -error "/cvmfs/oasis.opensciencegrid.org/." "WN_Resource" "CVMFS oasis not found" "file" "/cvmfs/oasis.opensciencegrid.org/."
exit 1
