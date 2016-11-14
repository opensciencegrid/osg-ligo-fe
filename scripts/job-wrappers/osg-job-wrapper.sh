#!/bin/bash

# Echo some varibles for debbuging
echo "Startup: `date`" 1>&2
echo "Node: `uname -n`" 1>&2
echo "Site: $GLIDEIN_Site" 1>&2
export GLIDEIN_Id=`grep -i '^Name' $_CONDOR_MACHINE_AD`
echo "PilotID: $GLIDEIN_Id" 1>&2

