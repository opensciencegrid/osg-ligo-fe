#!/bin/bash

# Echo some varibles for debbuging
echo "Startup: `date`" 1>&2
echo "Node: `uname -n`" 1>&2
echo "Site: $GLIDEIN_Site" 1>&2
export GLIDEIN_Id=`grep -i '^Name' $_CONDOR_MACHINE_AD`
echo "PilotID: $GLIDEIN_Id" 1>&2

# Handle LAL data
LAL_DATA_PATH=$(readlink -f $LAL_DATA_PATH)
# note [[ has different semantics from [ in bash
if [[ "$LAL_DATA_PATH" == /cvmfs/* ]]; then
  echo "Using CVMFS for LAL data" 1>&2
elif [ -z "$LAL_DATA_PATH" ]; then
  # do nothing
  echo "$LAL_DATA_PATH is unset by job."
else
  # Create a copy of $LAL_DATA_PATH locally if it does not already exist.
  if [ -d ../../lal_data ]; then
    export LAL_DATA_PATH=`readlink -f ../../lal_data`
  elif [ -d $LAL_DATA_PATH ]; then
    TMP_LAL_DATA_PATH=`mktemp -d ../../lal_data.inprogress.XXXXXX`
    cp -r "$LAL_DATA_PATH"/* "$TMP_LAL_DATA_PATH"
    export LAL_DATA_PATH=`readlink -f ../../lal_data`
    mv -T $TMP_LAL_DATA_PATH $LAL_DATA_PATH
    if [ $? -ne 0 ]; then
      rm -rf "$TMP_LAL_DATA_PATH"
    fi
  fi
fi
echo "Using $LAL_DATA_PATH for LAL_DATA_PATH" 1>&2

